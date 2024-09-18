variable "organization_name" {
  type        = string
  description = "The name of the Terraform Cloud organization"
}

variable "tfe_token" {
  type        = string
  description = "The API token for Terraform Cloud"
  sensitive   = true
}

variable "project_name" {
  type        = string
  description = "The name of the project to create"
  default     = "NMBS_Infra"  # Set the default project name
}

# List of workspace names
variable "workspace_names" {
  type        = list(string)
  description = "The names of the workspaces to create"
  default     = ["NMBS_PROD", "NMBS_TEST", "NMBS_STAGE"]
}

# Define Team Name
variable "team_name" {
    type = string
    description = "Define the team name to create"
    default = "NMBS_Infra_Team"  
}