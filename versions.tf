terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  cloud {
    organization = "jacobm"

    workspaces {
      name = "keith-tfc-test"
    }
  }

}

provider "vault" {
  address = "https://vault.control.acceleratorlabs.ca"
}

provider "azurerm" {
  client_id                  = data.vault_azure_access_credentials.creds.client_id
  client_secret              = data.vault_azure_access_credentials.creds.client_secret
  subscription_id            = "ec23b771-c691-4929-b109-ebf808e51506"
  tenant_id                  = "4328f5c5-4e1f-4b4d-b5ee-604e7fe12ccf"
  # skip_provider_registration = true
  features {}
}

 data "vault_azure_access_credentials" "creds" {
  role            = "keith-m-leung"
  validate_creds  = true
  subscription_id = "ec23b771-c691-4929-b109-ebf808e51506"
  backend         = "azure"
}