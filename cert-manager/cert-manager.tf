variable "cert_manager_version" {
  default = "v0.14.3"
}

terraform {
  required_providers {
    helm       = "~> 1.1"
    kubernetes = "~> 1.11"
    null       = "~> 2.1"
  }
}

provider kubernetes {
}

provider "helm" {
  kubernetes {
  }
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
    name = "cert-manager"
  }
}

resource "null_resource" "cert-manager" {

  provisioner "local-exec" {
    when       = create
    command    = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/${var.cert_manager_version}/cert-manager.crds.yaml"
    on_failure = fail
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.14.3/cert-manager.crds.yaml"
    on_failure = fail
  }
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  namespace = "cert-manager"
  chart     = "jetstack/cert-manager"
  version   = var.cert_manager_version

  depends_on = [null_resource.cert-manager]
}
