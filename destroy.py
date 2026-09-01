from subprocess import run
import os
import shutil
from deployend.py_main_modules.main_module import terraform_destroy
import json

with open("recall_config.json", "r") as var_file:
    variables = json.load(var_file)
s3_bucket_name = variables["deployend"]["existing_s3_bucket"]

server = "recall"
infra_dir = "./deployend/infrastructure"
log_dir = "./deployend/logs/infrastructure"
# Destroy Recall server
terraform_destroy(infra_dir, server, log_dir)


recall_ssh_keys_dir = "./deployend/infrastructure/.ssh_keys"
print(f"-----Removing SSH keys {server}")
if os.path.isdir(recall_ssh_keys_dir):
    shutil.rmtree(recall_ssh_keys_dir)


fe_tmp_sv_outputs = "./deployend/.fe_tmp_sv_outputs.json"
backend_userdata = "./deployend/backend_userdata.sh"
recall_tf_outputs = "./deployend/infrastructure/.recall_outputs.json"
tf_init_log = "./deployend/logs/infrastructure/tf_init.log"
tf_apply_target_log = "./deployend/logs/infrastructure/tf_apply_target.log"
tf_apply_log = "./deployend/logs/infrastructure/tf_apply.log"
generated_files = [fe_tmp_sv_outputs, backend_userdata, recall_tf_outputs, tf_apply_log, tf_apply_target_log, tf_init_log]

for filepath in generated_files:
    if os.path.exists(filepath):
        os.remove(filepath)
        print(f"-----removed {filepath}")

print(f"Emptying {s3_bucket_name} bucket content")
run(["aws", "s3", "rm", f"s3://{s3_bucket_name}", "--recursive"], check=True)

print(f"-----{server} Infrastructure destroyed successfully!")
