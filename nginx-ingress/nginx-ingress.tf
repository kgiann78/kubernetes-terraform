provider "kubernetes" {}

provider "helm" {
  kubernetes {}
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "nginx-ingress"
  wait = "false"

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
      name =  "controller.publishService.enabled"
      value = "true"
  }
  
  set {
      name =  "controller.hostNetwork"
      value = "true"
  }
  
  set {
      name =  "controller.daemonset.useHostPort"
      value = "true"
  }
  
  set {
      name =  "dnsPolicy"
      value = "ClusterFirstWithHostNet"
  }
  
  set {
      name =  "controller.kind"
      value = "DaemonSet"
  }
}