resource "digitalocean_firewall" "sharecar-fw" {
  name  = "sharecar-fw"
  #tags  = ["sharecar"]
  count = "1"

  inbound_rule {
      protocol                = "tcp"
      port_range              = "22"
      source_addresses        = ["0.0.0.0/0", "::/0"]
    }
  inbound_rule {
      protocol                = "tcp"
      port_range              = "8000"
      source_addresses        = ["188.166.184.204/32"]
    }
  inbound_rule {
      protocol                = "tcp"
      port_range              = "3000"
      source_addresses        = ["188.166.184.204/32"]
    }

  inbound_rule {
      protocol                = "tcp"
      port_range              = "4000"
      source_addresses        = ["188.166.184.204/32"]
    }

  outbound_rule {
      protocol                = "tcp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
  outbound_rule {
      protocol                = "udp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
  outbound_rule {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    }
}