terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.16.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}


data "digitalocean_kubernetes_cluster" "main_cluster" {
  name = "loki-test"
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.main_cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = data.digitalocean_kubernetes_cluster.main_cluster.endpoint
    token = data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      data.digitalocean_kubernetes_cluster.main_cluster.kube_config[0].cluster_ca_certificate
    )
  }
}
