provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "minikube"
  }
}

resource "kubernetes_namespace" "data" {
  metadata {
    name = "data"
  }
}

resource "kubernetes_namespace" "api" {
  metadata {
    name = "api"
  }
}

resource "kubernetes_namespace" "web" {
  metadata {
    name = "web"
  }
}

resource "kubernetes_deployment" "eric" {
  metadata {
    name      = "eric-api"
    namespace = "api"
    labels = {
      app = "inspire-eric"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "inspire-eric"
      }
    }

    template {
      metadata {
        labels = {
          app = "inspire-eric"
        }
      }

      spec {
        container {
          image = "joshuarose/inspire-eric:v0.1"
          name  = "eric"
          liveness_probe {
            http_get {
              path = "/api/eric"
              port = 3030
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "chadiamond" {
  metadata {
    name      = "chadiamond-api"
    namespace = "api"
    labels = {
      app = "inspire-chadiamond"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "inspire-chadiamond"
      }
    }

    template {
      metadata {
        labels = {
          app = "inspire-chadiamond"
        }
      }

      spec {
        container {
          image = "joshuarose/inspire-chadiamond:v0.1"
          name  = "chadiamond"
          liveness_probe {
            http_get {
              path = "/api/chadiamond"
              port = 5000
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "brooke" {
  metadata {
    name      = "brooke-api"
    namespace = "api"
    labels = {
      app = "inspire-brooke"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "inspire-brooke"
      }
    }

    template {
      metadata {
        labels = {
          app = "inspire-brooke"
        }
      }

      spec {
        container {
          image = "joshuarose/inspire-brooke:v0.1"
          name  = "brooke"
          liveness_probe {
            http_get {
              path = "/api/brooke"
              port = 8000
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "web" {
  metadata {
    name      = "web"
    namespace = "web"
    labels = {
      app = "web"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "web"
      }
    }

    template {
      metadata {
        labels = {
          app = "web"
        }
      }

      spec {
        container {
          image = "joshuarose/inspire-web:v0.3" //v3
          image_pull_policy = "IfNotPresent"
          name  = "web"
          env_from {
            config_map_ref {
              name = "web-config"
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            //needs a bit more time between requests and timeouts
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 5
          }
        }
      }
    }
  }
  //redis first
  depends_on  = [ helm_release.redis ]
}


resource "kubernetes_service" "brooke" {
  metadata {
    name      = "brooke"
    namespace = "api"
  }
  spec {
    selector = {
      app = "inspire-brooke"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8000
      target_port = 8000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "eric" {
  metadata {
    name      = "eric"
    namespace = "api"
  }
  spec {
    selector = {
      app = "inspire-eric"
    }
    session_affinity = "ClientIP"
    port {
      port        = 3030
      target_port = 3030
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "chadiamond" {
  metadata {
    name      = "chadiamond"
    namespace = "api"
  }
  spec {
    selector = {
      app = "inspire-chadiamond"
    }
    session_affinity = "ClientIP"
    port {
      port        = 5000
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name      = "web"
    namespace = "web"
  }
  spec {
    selector = {
      app = "web"
    }
    session_affinity = "ClientIP"
    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_config_map" "db_config" {
  metadata {
    name      = "db-config"
    namespace = "data"
    labels = {
      app = "db"
    }
  }

  data = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "password"
  }
}

resource "kubernetes_config_map" "web_config" {
  metadata {
    name      = "web-config"
    namespace = "web"
    labels = {
      app = "web"
    }
  }

  data = {
    RAILS_ENV                = "production"
    RAILS_SERVE_STATIC_FILES = "true"
  }
}

resource "kubernetes_service" "db" {
  metadata {
    name      = "db"
    namespace = "data"
    labels = {
      app = "db"
    }
  }

  spec {
    selector = {
      app = "db"
    }
    session_affinity = "ClientIP"
    port {
      port        = 5432
      target_port = 5432
    }
    cluster_ip = "None"
  }
}

resource "kubernetes_stateful_set" "db" {
  metadata {
    name      = "db"
    namespace = "data"
  }

  spec {
    service_name = "db"
    replicas     = "1"
    selector {
      match_labels = {
        app = "db"
      }
    }

    volume_claim_template {
      metadata {
        name = "db"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"

        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }
      spec {
        container {
          name              = "db"
          image             = "postgres"
          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = "db-config"
            }
          }

          port {
            name           = "db"
            container_port = 5432
          }

          volume_mount {
            name       = "db"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "db"
          }
        }
      }
    }
  }
}

# TODO: Deploying this chart takes down our web pods. Why?
resource "helm_release" "redis" {
   name  = "redis"
   namespace = "data"
   chart = "https://charts.bitnami.com/bitnami/redis-10.7.16.tgz"
 }  
 
resource "helm_release" "traefik" {
  name  = "traefik"
  namespace = "web"
  repository = "https://helm.traefik.io/traefik"
  chart            = "traefik"
}
