variable "env_name" {}

resource "newrelic_alert_policy" "DemoPolicy" {
  name = "${var.env_name}: My Demo Policy"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}

resource "newrelic_alert_channel" "DemoChannel" {
  name = "${var.env_name}: My Demo Channel"
  type = "email"

  config {
    recipients              = "jbuchanan@newrelic.com"
    include_json_attachment = "1"
  }
}

resource "newrelic_alert_policy_channel" "ChannelSubs" {
  policy_id  = newrelic_alert_policy.DemoPolicy.id
  channel_ids = [
    newrelic_alert_channel.DemoChannel.id
  ]
}

module "HostConditions" {
  source = "git::https://github.com/jsbnr/demo-terraform.git"
  policyId = newrelic_alert_policy.DemoPolicy.id
  cpu_critical = 88
  cpu_warning = 78 
  diskPercent = 68
}