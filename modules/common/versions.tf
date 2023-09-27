terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.15.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    } 
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }  
    local = {
      source  = "hashicorp/local"
      version = ">= 2.3.0"
    }            
  }
}
