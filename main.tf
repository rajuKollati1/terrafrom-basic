terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
  }
}

# Configure the Kubernetes provider to connect to your cluster
# It will use the kubeconfig file from your laptop.
provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# 1. Create a dedicated Namespace for our application
resource "kubernetes_namespace_v1" "app_namespace" {
  metadata {
    name = "${var.app_name}-ns"
  }
}

# 2. Create the NGINX Deployment
resource "kubernetes_deployment_v1" "nginx_deployment" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.app_namespace.metadata.0.name
    labels = {
      app = var.app_name
    }
  }
  spec {
    replicas = var.app_replicas
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        container {
          image = "nginx:1.23"
          name  = var.app_name
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# 3. Expose the Deployment with a Service
resource "kubernetes_service_v1" "nginx_service" {
  metadata {
    name      = "${var.app_name}-svc"
    namespace = kubernetes_namespace_v1.app_namespace.metadata.0.name
  }
  spec {
    selector = {
      app = var.app_name
    }
    port {
      port        = 80
      target_port = 80
    }
    # Use LoadBalancer to expose the service externally.
    # For internal-only, you could use "ClusterIP".
    type = "LoadBalancer"
  }
}
