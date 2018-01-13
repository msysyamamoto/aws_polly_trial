variable "region" {
  default = "us-west-2"
}

variable "whitelisted_ips" {
  type = "list"

  # IP Allow list
  default = [
    {
      value = "2001:db8::/32"
      type  = "IPV6"
    },
    {
      value = "192.0.2.0/24"
      type  = "IPV4"
    }
  ]
}
