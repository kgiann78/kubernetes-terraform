resource "null_resource" "tls-certificate" {

  provisioner "local-exec" {
    when       = create
    command    = "kubectl apply -f letsencrypt-issuer.yaml"
    on_failure = fail
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl delete -f letsencrypt-issuer.yaml"
    on_failure = fail
  }
}