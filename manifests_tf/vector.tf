# The problem we have is we want stuff like {{ kubernetes.blah }} in a yaml file
# but helm tries to do templating and then complains kubernetes is not a function
# so {{`blah`}} lets us define "raw strings"
locals {
  values_config = <<EOT
customConfig:
  sources:
    kubernetes-logs:
      type: kubernetes_logs
  sinks:
    loki:
      encoding:
        codec: json
      endpoint: http://loki:3100
      inputs:
        - kubernetes-logs
      labels:
        source: "{{`{{ source_type }} `}}"
        kubernetes_container_name: "{{`{{ kubernetes.container_name }}`}}"
        kubernetes_pod_name: "{{`{{ kubernetes.pod_name }}`}}"
        kubernetes_pod_namespace: "{{`{{ kubernetes.pod_namespace }}`}}"
        kubernetes_pod_ip: "{{`{{ kubernetes.pod_ip }}`}}"
        kubernetes_node: "{{`{{ kubernetes.pod_node_name }}`}}"
      type: loki
EOT
}

resource "helm_release" "vector" {
  name       = "vector"
  repository = "https://helm.vector.dev"
  chart      = "vector-agent"
  version    = "0.19.1"
  values     = [local.values_config]
}
