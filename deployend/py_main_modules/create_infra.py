
from main_module import *
from shutil import rmtree

# INFRASTRUCTURE
# ---------------------------------------------------------------------------------------------
# Creating Server

infra_dir = "../infrastructure"

be_key_name = "r-backend-sv-key"
bastion_key_name = "r-bastion-sv-key"
fe_key_name = "r-frontend-sv-key"
log_dir = "../logs/infrastructure"

server = "recall"

generate_ssh_keys(be_key_name, infra_dir)
generate_ssh_keys(bastion_key_name, infra_dir)
generate_ssh_keys(fe_key_name, infra_dir)

terraform_init(infra_dir, server, log_dir)
terraform_apply_target(infra_dir, "ssl_cert", server, log_dir)
terraform_apply(infra_dir, server, log_dir)

server = "fe_tmp_sv"
infra_dir="../fe_tmp_sv/tmp_sv"
log_dir = "../logs/fe_tmp_sv"
terraform_destroy(infra_dir, server, log_dir)

tmp_sv_ssh_keys_dir = "../fe_tmp_sv/tmp_sv/.ssh_keys"
print(f"-----Removing SSH keys {server}")
if os.path.isdir(tmp_sv_ssh_keys_dir):
    rmtree(tmp_sv_ssh_keys_dir)

tmp_sv_config_key = "../fe_tmp_sv/tmp_sv_config/.tmp_sv_key"
tmp_sv_config_inventory = "../fe_tmp_sv/tmp_sv_config/inventory"
tmp_be_sv_config_key = "../fe_tmp_sv/tmp_backend_sv_config/.tmp_sv_key"
tmp_be_sv_config_inventory = "../fe_tmp_sv/tmp_backend_sv_config/inventory"
generated_files = [tmp_sv_config_key, tmp_sv_config_inventory, tmp_be_sv_config_key, tmp_be_sv_config_inventory]
for filepath in generated_files:
    if os.path.exists(filepath):
        os.remove(filepath)
        print(f"-----removed {filepath}")