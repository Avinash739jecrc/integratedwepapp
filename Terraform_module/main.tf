provider "azurerm" {
  features {}
  subscription_id = "fbeeaed1-f074-4dc0-a3a5-eb74529a46e3"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-jenkins"
  location = var.location
}

resource "azurerm_service_plan" "this" {
  name                = "appserviceplanaryan01"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"

  sku_name = "B1"

}

resource "azurerm_linux_web_app" "this" {
  name                = "webapijenkinsavinash"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  service_plan_id     = azurerm_service_plan.this.id  # Updated attribute

  site_config {
    always_on = true
    
    application_stack {
      dotnet_version = "8.0"
    }
  }
}