resource "digitalocean_kubernetes_cluster" "main_cluster" {
  name    = "loki-test"
  region  = "lon1"
  version = "1.21.5-do.0"

  auto_upgrade = true

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
    auto_scale = false
  }
}

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.main_cluster.kube_config[0].raw_config
}
