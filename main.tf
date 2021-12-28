terraform{
    required_providers{
        docker ={
            source ="kreuzwerker/docker"
            version = "~> 2.15.0"
        }
    }
}

provider "docker"{
    host    = "npipe:////.//pipe//docker_engine"
}


resource "docker_image" "nginx"{
    name = "nginx:latest"
    keep_locally = true
}

resource "docker_container" "nginx"{
    image= docker_image.nginx.latest
    name = "tutorial"
    ports{
        internal = 80
        external = 8000
    }
}

resource "docker_service" "nginx_service" {
  name = "nginx_service"
  task_spec {
    container_spec{
        image = docker_image.nginx.repo_digest
    }
  }
  mode {
    replicated{
        replicas =2
    }
  }
  endpoint_spec {
    ports{
        published_port =8081
        target_port = 80
    }
  }
}