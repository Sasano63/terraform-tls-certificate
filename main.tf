# Root private key
resource "tls_private_key" "root" {
  algorithm   = "${var.algorithm}"
  ecdsa_curve = "${var.ecdsa_curve}"
}

# Root certificate
resource "tls_self_signed_cert" "root" {
  key_algorithm   = "${tls_private_key.root.algorithm}"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  subject {
    common_name  = "${var.common_name}"
    organization = "${var.organization}"
  }
  
  
  dns_names = [
    # Consul
    "${var.namespace}-server-${count.index}.node.consul",
    "${var.namespace}-server-${count.index}.node.${var.region}.consul",

    "*.service.consul",
    "*.service.${var.region}.consul",
    "*.query.consul",
    "consul.service.consul",

    # Nomad
    "nomad.service.consul",
    "nomad.service.${var.region}.consul",


    "client.global.nomad",
    "server.global.nomad",

    # Vault
    "vault.service.consul",
    "vault.query.consul",
    "active.vault.service.consul",
    "active.vault.service.${var.region}.consul",
    "standby.vault.service.consul",
    "standby.vault.service.${var.region}.consul",
    "performance-standby.vault.service.consul",
    "performance-standby.vault.service.${var.region}.consul",

    # Common
    "localhost",
    "*.${var.namespace}.${data.aws_route53_zone.fdqn.name}",
    "server-0.eu-guystack.original.aws.hashidemos.io",
    "server-1.eu-guystack.original.aws.hashidemos.io",
    "server-2.eu-guystack.original.aws.hashidemos.io",
  ]


  validity_period_hours = "${var.validity_period_hours}"

  allowed_uses = [
    "cert_signing",
    "digital_signature",
    "crl_signing",
  ]

  is_ca_certificate = "${var.is_ca_certificate}"
}


# Consul gossip encryption key
resource "random_id" "consul_gossip_key" {
  byte_length = 16
}

# Consul master token
resource "random_id" "consul_master_token" {
  byte_length = 16
}

# Consul join key
resource "random_id" "consul_join_tag_value" {
  byte_length = 16
}

# Nomad gossip encryption key
resource "random_id" "nomad_gossip_key" {
  byte_length = 16
}
