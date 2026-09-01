from subprocess import run
from json import load

with open("recall_config.json", "r") as var_file:
    variables = load(var_file)
s3_bucket_name = variables["deployend"]["existing_s3_bucket"]

run(["python3", "frontend_env.py"], cwd="deployend/py_main_modules", check=True)

run(["pnpm", "install"], cwd="frontend", check=True)

run(["pnpm", "build"], cwd="frontend", check=True)

run(["aws", "s3", "sync", "./frontend/dist", f"s3://{s3_bucket_name}"], check=True)

run(["python3", "create_launch_temp.py"], cwd="deployend/py_main_modules", check=True)

run(["python3", "backend_userdata.py"], cwd="deployend/py_main_modules", check=True)

run(["python3", "create_infra.py"], cwd="deployend/py_main_modules", check=True)
