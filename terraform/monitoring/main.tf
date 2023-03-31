locals {
  #  opsgenie_notification_channel = "l_iaPw6nk"
  #  notifications = (
  #    module.this.stage == "prod" ?
  #    "[{\"uid\": \"${local.opsgenie_notification_channel}\"}]" :
  #    "[]"
  #  )
}

data "jsonnet_file" "dashboard" {
  source = "${path.module}/dashboard.jsonnet"

  ext_str = {
    dashboard_title = module.this.id
    prometheus_uid  = grafana_data_source.prometheus.uid
  }
}

# JSON Dashboard. When exporting from Grafana make sure that all
# variables are replaced properly
resource "grafana_dashboard" "at_a_glance" {
  overwrite   = true
  message     = "Updated by Terraform"
  config_json = data.jsonnet_file.dashboard.rendered
}
