variable "openfaas_staging_ingress_values" {
  default = "../tls-certificates/openfaas/openfaas_staging_ingress_values.yaml"
}

variable "openfaas_prod_ingress_values" {
  default = "../tls-certificates/openfaas/openfaas_ingress_values_le_traefik_prod.yaml"
}
