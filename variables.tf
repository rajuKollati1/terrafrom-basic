variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for Kubernetes cluster access. Defaults to ~/.kube/config."
  type        = string
  default     = "~/.kube/config"
}

variable "app_name" {
  description = "The name for the deployment and service."
  type        = string
  default     = "nginx-example-app"
}

variable "app_replicas" {
  description = "Number of pod replicas for the application."
  type        = number
  default     = 2
}
