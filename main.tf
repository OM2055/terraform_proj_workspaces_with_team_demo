terraform {
  cloud {
    organization = var.organization_name
    workspaces {
      name = "infra-team-workspaces"
    }
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token
}

# Step 1: Create the InfraTeam team
resource "tfe_team" "infra_team" {
  name         = "InfraTeam"
  organization = var.organization_name
}

# Step 2: Create the Project01 project
resource "tfe_project" "project01" {
  name         = "Project01"
  organization = var.organization_name
}

# Step 3: Create 3 workspaces within the organization (without the project attribute)
variable "workspace_names" {
  type    = list(string)
  default = ["workspace1", "workspace2", "workspace3"]
}

resource "tfe_workspace" "project01_workspaces" {
  for_each     = toset(var.workspace_names)
  name         = each.value
  organization = var.organization_name
}

# Step 4: Assign workspaces to the Project01 using tfe_workspace_project_assignment
resource "tfe_workspace_project_assignment" "project_assignment" {
  for_each    = tfe_workspace.project01_workspaces
  workspace_id = each.value.id
  project_id   = tfe_project.project01.id
}

# Step 5: Assign 'admin' access to InfraTeam for each workspace
resource "tfe_team_access" "infra_team_workspace_access" {
  for_each     = tfe_workspace.project01_workspaces
  team_id      = tfe_team.infra_team.id
  workspace_id = each.value.id
  access       = "admin"  # Set access level to 'admin'
}
