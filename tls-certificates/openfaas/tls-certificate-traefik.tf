resource "null_resource" "tls-certificate" {

  provisioner "local-exec" {
    when       = create
    command    = "kubectl apply -f openfaas_letsencrypt-issuer_traefik.yaml"
    on_failure = fail
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl delete -f openfaas_letsencrypt-issuer_traefik.yaml"
    on_failure = fail
  }
}
