import os
import subprocess
import json
from main_module import *

# FRONTEND AWS AMI/TEMPLATE SERVER
# ---------------------------------------------------------------------------------------------
# Creating Server
fe_tmp_sv_dir = "../fe_tmp_sv/tmp_sv"
sv_name = "fe_tmp_sv"
sv_key_name = "tmp_sv_key"
log_dir = "../logs/fe_tmp_sv"
outputs_location = ".."

generate_ssh_keys(sv_key_name, fe_tmp_sv_dir)
terraform_init(fe_tmp_sv_dir, sv_name, log_dir)
terraform_apply(fe_tmp_sv_dir, sv_name, log_dir)
terraform_outputs(fe_tmp_sv_dir, sv_name, outputs_location)

# Configuring server (fe_tmp_sv)
fe_tmp_sv_outputs = f"../.{sv_name}_outputs.json"
fe_tmp_sv_key_path = f"../fe_tmp_sv/tmp_sv/.ssh_keys/{sv_key_name}"
ansible_dir = f"../fe_tmp_sv/tmp_sv_config"
ansible_inventory_file = "../fe_tmp_sv/tmp_sv_config/inventory"
log_dir = "../logs/fe_tmp_sv"

with open(fe_tmp_sv_outputs, "r") as var_file:
    outputs = json.load(var_file)
fe_tmp_sv_ip = outputs["tmp_frontend_public_ip"]["value"]
be_tmp_sv_ip = outputs["tmp_backend_public_ip"]["value"]

# Copy ssh key to Ansible configuration directory
print("-----Copying ssh_keys to server-config directory")
subprocess.run(["cp", fe_tmp_sv_key_path, f"{ansible_dir}/.{sv_key_name}"])
# subprocess.run(["mv", f"{ansible_dir}/{sv_key_name}", f"{ansible_dir}/.{sv_key_name}"])
subprocess.run(["chmod", "600", f"{ansible_dir}/.{sv_key_name}"])
log_dir = "../logs/fe_tmp_sv"

generate_ansible_inventory(
    fe_tmp_sv_ip, "ubuntu", f".{sv_key_name}", ansible_inventory_file
)
run_ansible_playbook(ansible_dir, sv_name, log_dir)


ansible_dir = f"../fe_tmp_sv/tmp_backend_sv_config"
ansible_inventory_file = f"{ansible_dir}/inventory"
log_dir = "../logs/be_tmp_sv"
sv_name = "backend_tmp_server"

# Copy ssh key to Ansible configuration directory
print("-----Copying ssh_keys to backend-server-config directory")
subprocess.run(["cp", fe_tmp_sv_key_path, f"{ansible_dir}/.{sv_key_name}"])

subprocess.run(["chmod", "600", f"{ansible_dir}/.{sv_key_name}"])

generate_ansible_inventory(
    be_tmp_sv_ip, "ubuntu", f".{sv_key_name}", ansible_inventory_file
)
run_ansible_playbook(ansible_dir, sv_name, log_dir)