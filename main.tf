terraform {
  cloud {
    organization = var.organization_name  # Replace with your organization
    workspaces {
      name = "terraform_proj_workspaces_with_team_demo"
    }
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.tfe_token  # Replace with your Terraform Cloud token
}

# Get the organization details using a data source
data "tfe_organization" "nmbsproject" {
  name = var.organization_name
}

# Create the project
resource "tfe_project" "nmbsproject" {
  name         = var.project_name
  organization = var.organization_name
}



# Create workspaces using for_each
resource "tfe_workspace" "workspaces" {
  for_each     = toset(var.workspace_names)
  name         = each.value  # Create workspaces with the names in the list
  organization = var.organization_name
  project_id    = tfe_project.nmbsproject.id # Link the workspace to the project
}

# Step 3: Create a new team
resource "tfe_team" "nmbs_team" {
  name         = var.team_name
  organization = var.organization_name
}

# Step 4: Add permissions for the team to the project
resource "tfe_team_project_access" "team_project_access" {
   team_id     = tfe_team.nmbs_team.id
   project_id  = tfe_project.nmbsproject.id 
   access      = "admin"
}

# Step 5: Add permissions for the team to each workspace
resource "tfe_team_access" "team_workspace_access" {
  for_each   = tfe_workspace.workspaces
  team_id    = tfe_team.nmbs_team.id
  workspace_id = each.value.id
  access     = "admin"
}
