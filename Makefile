proxmox_user := ${PROXMOX_TF_USER}
proxmox_pass := ${PROXMOX_TF_PASS}
proxmox_ip := ${PROXMOX_TF_IP}
proxmox_ssh_key := ${PROXMOX_SSH_KEY}
proxmox_token_secret := ${PROXMOX_TOKEN_SECRET}
proxmox_token_id := ${PROXMOX_TOKEN_ID}
local_ssh_file := ${LOCAL_SSH_FILE}
private_ssh_key := ${PRIVATE_SSH_KEY}
password := ${CI_PASSWORD}
git_user:=${USER}
git_password:=${GIT_PASSWORD}
### proxmox_terraform_values
plan_name := "cluster_state.plan"
TERRAFORM_PROX=TF_VAR_USER="$(git_user)" TF_VAR_GIT_PASSWORD="$(git_password)" TF_VAR_CI_PASSWORD="$(password)" TF_VAR_PRIVATE_SSH_KEY="$(local_ssh_file)" TF_VAR_LOCAL_SSH_FILE="$(local_ssh_file)" TF_VAR_PROXMOX_TF_USER="$(proxmox_user)" TF_VAR_PROXMOX_TF_PASS="$(proxmox_pass)"  TF_VAR_PROXMOX_TF_IP="$(proxmox_ip)" TF_VAR_PROXMOX_SSH_KEY="$(proxmox_ssh_key)" TF_VAR_PROXMOX_TOKEN_SECRET="$(proxmox_token_secret)" TF_VAR_PROXMOX_TOKEN_ID="$(proxmox_token_id)" terraform

load-env:
	pwd && . .env

proxmox-tf-init:
	@cd proxmox/ && terraform init \
    -backend-config="username=$(git_user)" \
    -backend-config="password=$(git_password)"

proxmox-tf-validate:
	cd proxmox/ && terraform validate

prox-init-reconfigure:
	@cd proxmox/ && terraform init \
    -backend-config="username=$(git_user)" \
    -backend-config="password=$(git_password)" \
    -reconfigure

prox-init-migrate:
	cd proxmox/ && $(TERRAFORM_PROX) init \
    -migrate-state

proxmox-tf-plan:
	@cd proxmox/ && $(TERRAFORM_PROX) plan

proxmox-tf-apply:
	@cd proxmox/ && $(TERRAFORM_PROX) apply

proxmox-tf-apply-gitlab:
	@cd proxmox/ && $(TERRAFORM_PROX) apply -auto-approve

proxmox-tf-unlock:
	@cd proxmox/ && $(TERRAFORM_PROX) force-unlock

proxmox-tf-destroy:
	@cd proxmox && $(TERRAFORM_PROX) destroy

proxmox-tf-statelist:
	@cd proxmox/ && $(TERRAFORM_PROX) state list

proxmox-tf-state-move:
	@cd proxmox/ && $(TERRAFORM_PROX) state mv -lock=false $(from) $(to)

proxmox-tf-import:
	@cd proxmox/ && $(TERRAFORM_PROX) import -lock=false $(target) $(source)

