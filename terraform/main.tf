terraform {
  required_version = ">= 1.3.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  worker_script = <<'JS'
export default {
  async scheduled(event, env, ctx) {
    ctx.waitUntil(triggerBuild(env));
  },

  async fetch(request, env) {
    return triggerBuild(env);
  },
};

async function triggerBuild(env) {
  if (!env.BUILD_WEBHOOK_URL) {
    return new Response(JSON.stringify({
      ok: false,
      message: "BUILD_WEBHOOK_URL is not configured.",
    }), {
      status: 500,
      headers: {
        "content-type": "application/json",
      },
    });
  }

  const response = await fetch(env.BUILD_WEBHOOK_URL, {
    method: "POST",
  });

  const body = await response.text();

  return new Response(JSON.stringify({
    ok: response.ok,
    status: response.status,
    statusText: response.statusText,
    body,
  }), {
    status: 200,
    headers: {
      "content-type": "application/json",
    },
  });
}
JS
}

resource "cloudflare_worker_script" "hourly_build" {
  account_id = var.cloudflare_account_id
  name       = var.worker_name
  module     = true
  content    = local.worker_script

  plain_text_binding {
    name = "BUILD_WEBHOOK_URL"
    text = var.build_webhook_url
  }
}

resource "cloudflare_worker_cron_trigger" "hourly" {
  account_id = var.cloudflare_account_id
  script_name = cloudflare_worker_script.hourly_build.name
  schedules   = ["0 * * * *"]
}
