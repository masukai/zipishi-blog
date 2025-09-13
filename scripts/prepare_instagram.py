#!/usr/bin/env python3
"""Prepare Instagram image, reel and caption from a blog post.

This script reads the front matter of a Markdown post and generates:
- a square 1080x1080 image based on the cover image
- a simple 5 second MP4 video (reel) using the same image
- a caption text file consisting of title and hashtags

Dependencies: ImageMagick (magick) and ffmpeg, PyYAML.
"""

import argparse
import pathlib
import subprocess
import sys

try:
    import yaml
except ImportError:
    print("PyYAML is required. Please install it first.", file=sys.stderr)
    sys.exit(1)


def parse_args():
    parser = argparse.ArgumentParser(description="Prepare Instagram media from a blog post")
    parser.add_argument("post", help="Path to the Markdown post file")
    parser.add_argument("--outdir", default="instagram_drafts", help="Output directory")
    return parser.parse_args()


def load_front_matter(post_path: pathlib.Path):
    text = post_path.read_text(encoding="utf-8")
    if not text.startswith("---"):
        return {}
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    front = parts[1]
    return yaml.safe_load(front) or {}


def make_caption(data):
    title = data.get("title", "")
    tags = data.get("tags", [])
    lines = [title, ""]
    lines.extend(f"#{tag}" for tag in tags)
    return "\n".join(lines)


def process_image(cover_path: pathlib.Path, dest_image: pathlib.Path, dest_video: pathlib.Path):
    # Create square 1080x1080 image
    subprocess.run([
        "magick",
        str(cover_path),
        "-resize",
        "1080x1080^",
        "-gravity",
        "center",
        "-extent",
        "1080x1080",
        str(dest_image),
    ], check=True)

    # Create a 5 second reel video from the image
    subprocess.run([
        "ffmpeg",
        "-y",
        "-loop",
        "1",
        "-i",
        str(dest_image),
        "-c:v",
        "libx264",
        "-t",
        "5",
        "-pix_fmt",
        "yuv420p",
        "-vf",
        "scale=1080:1080",
        str(dest_video),
    ], check=True)


def main():
    args = parse_args()
    post_path = pathlib.Path(args.post)
    data = load_front_matter(post_path)

    out_dir = pathlib.Path(args.outdir) / post_path.stem
    out_dir.mkdir(parents=True, exist_ok=True)

    caption = make_caption(data)
    (out_dir / "caption.txt").write_text(caption, encoding="utf-8")

    cover_rel = data.get("cover", {}).get("image")
    if cover_rel:
        # In Hugo, cover paths start with / and are located under the static directory
        cover_path = pathlib.Path("static") / cover_rel.lstrip("/")
        dest_image = out_dir / "image.jpg"
        dest_video = out_dir / "reel.mp4"
        if cover_path.exists():
            process_image(cover_path, dest_image, dest_video)
        else:
            print(f"Cover image not found: {cover_path}", file=sys.stderr)
    else:
        print("No cover image specified in front matter", file=sys.stderr)

    print(f"Draft prepared in {out_dir}")


if __name__ == "__main__":
    main()
