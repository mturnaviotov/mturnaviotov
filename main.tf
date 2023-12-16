provider "github" {
  token = var.auth
  owner = var.owner
}

resource "github_repository" "owner" {
  name        = var.owner
  description = "This is my Github account profile created by TerraForm with TerraForm scripts included"
  visibility  = "public"
  auto_init   = true
}

resource "github_branch" "development" {
  repository = github_repository.owner.name
  branch     = "development"
}

resource "github_branch_default" "development" {
  repository = var.owner
  branch     = github_branch.development.branch
}

variable "files" {
  type    = list(string)
  default = ["README.md", "main.tf", ".gitignore", ".terraform.lock.hcl", "variables.default"]
}

resource "github_repository_file" "files" {
  for_each   = toset(var.files)
  repository = github_repository.owner.name
  branch     = github_branch.development.branch
  file       = each.value
  content    = file("${each.value}")
  #  commit_message      = "${each.value} added"
  commit_author       = var.owner
  commit_email        = "${var.owner}@github.com"
  overwrite_on_create = true
}

# resource "github_repository_file" "README" {
#   repository          = github_repository.owner.name
#   branch              = github_branch.development.branch
#   file                = "README.md"
#   content             = file("./README.md")
#   commit_message      = "README.md added"
#   commit_author       = var.owner
#   commit_email        = "${var.owner}@github.com"
#   overwrite_on_create = true
# }

# resource "github_repository_file" "terraformlock" {
#   repository          = github_repository.owner.name
#   branch              = github_branch.development.branch
#   file                = ".terraform.lock.hcl"
#   content             = file("./.terraform.lock.hcl")
#   commit_message      = ".terraform.lock.hcl added"
#   commit_author       = var.owner
#   commit_email        = "${var.owner}@github.com"
#   overwrite_on_create = true
# }

# resource "github_repository_file" "variables" {
#   repository          = github_repository.owner.name
#   branch              = github_branch.development.branch
#   file                = "variables.default"
#   content             = file("./variables.default")
#   commit_message      = "Terraform variables.tf script added"
#   commit_author       = var.owner
#   commit_email        = "${var.owner}@github.com"
#   overwrite_on_create = true
# }

# resource "github_repository_file" "maintf" {
#   repository          = github_repository.owner.name
#   branch              = github_branch.development.branch
#   file                = "main.tf"
#   content             = file("./main.tf")
#   commit_message      = "Terraform main.tf script added"
#   commit_author       = var.owner
#   commit_email        = "${var.owner}@github.com"
#   overwrite_on_create = true
# }
