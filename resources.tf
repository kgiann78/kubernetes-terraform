resource "kubernetes_namespace" "openfaas" {
  metadata {
    labels = {
      role = "openfaas-system"
      access = "openfaas-system"
      istio-injection = "enabled"
    }

    name = "openfaas"
  }
}

resource "kubernetes_namespace" "openfaas-fn" {
  metadata {
    labels = {
      role = "openfaas-fn"
      istio-injection = "enabled"
    }

    name = "openfaas-fn"
  }
}

data "helm_repository" "openfaas" {
  name = "openfaas"
  url  = "https://openfaas.github.io/faas-netes/"
}

resource "helm_release" "openfaas" {
  name       = "openfaas"
  repository = data.helm_repository.openfaas.metadata[0].name
  chart      = "openfaas/openfaas"
  namespace  = "openfaas"
  
  set {
      name  = "functionNamespace"
      value = "openfaas-fn"
  }

  set {
      name  = "generateBasicAuth"
      value = "false"
  }
}