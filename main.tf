terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~>1.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  description = "Token API digitalocean"
}

resource "digitalocean_vpc" "do_vpc" {
  name        = "terraform-vpc"
  region      = "nyc1"
  ip_range    = "10.10.0.0/16"
  description = "VPC for terraform infrastructure"
}

resource "digitalocean_firewall" "do_fw" {
  name = "terraform-fw"
  droplet_ids = [digitalocean_vpc.do_vpc.id]

  inbound_rule {
    protocol = "tcp"
    port_range = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

    inbound_rule {
    protocol = "tcp"
    port_range = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["10.10.0.0/16"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "3306"
    source_addresses = ["10.10.0.0/16"]
  }

  outbound_rule {
  protocol             = "tcp"
  port_range           = "all"
  destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_loadbalancer" "do_lb" {
  name = "terraform-lb"
  region = "nyc1"

  forwarding_rule {
    entry_port = 443
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"

  }

  healthcheck {
    port = 80
    protocol = "http"
    check_interval_seconds = 10
    response_timeout_seconds = 5
    unhealthy_threshold = 3
    healthy_threshold = 2
    path = "/health"
  }

  droplet_ids = [
    digitalocean_droplet.do_droplet_1.id,
    digitalocean_droplet.do_droplet_2.id
  ]
}

resource "digitalocean_droplet" "do_droplet_1" {
  name = "terraform-droplet-1"
  region = "nyc1"
  size = "s-1vcpu-2gb"
  image = "ubuntu-20-04-x64"
  vpc_uuid = digitalocean_vpc.do_vpc.id
}

resource "digitalocean_droplet" "do_droplet_2" {
  name = "terraform-droplet-2"
  region = "nyc1"
  size = "s-1vcpu-2gb"
  image = "ubuntu-20-04-x64"
  vpc_uuid = digitalocean_vpc.do_vpc.id
}
