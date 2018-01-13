resource "aws_waf_ipset" "ipset_office" {
  name               = "IPSet_Office"
  ip_set_descriptors = "${var.whitelisted_ips}"
}

resource "aws_waf_rule" "wafrule" {
  depends_on  = ["aws_waf_ipset.ipset_office"]
  name        = "WAFRule"
  metric_name = "WAFRule"

  predicates {
    data_id = "${aws_waf_ipset.ipset_office.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on  = ["aws_waf_ipset.ipset_office", "aws_waf_rule.wafrule"]
  name        = "tfWebACL"
  metric_name = "tfWebACL"

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.wafrule.id}"
    type     = "REGULAR"
  }
}
