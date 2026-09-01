import json

recall_config = "../../recall_config.json"

with open(recall_config, "r") as var_file:
    env_var = json.load(var_file)

vite_api_url=env_var["frontend"]["vite_api_url"]
vite_firebase_api_key=env_var["frontend"]["vite_firebase_api_key"]
vite_firebase_auth_domain=env_var["frontend"]["vite_firebase_auth_domain"]
vite_firebase_project_id=env_var["frontend"]["vite_firebase_project_id"]
vite_firebase_storage_bucket=env_var["frontend"]["vite_firebase_storage_bucket"]
vite_firebase_messaging_sender_id=env_var["frontend"]["vite_firebase_messaging_sender_id"]
vite_firebase_app_id=env_var["frontend"]["vite_firebase_app_id"]

env_variables = f"""
VITE_API_URL={vite_api_url}
VITE_FIREBASE_API_KEY={vite_firebase_api_key}
VITE_FIREBASE_AUTH_DOMAIN={vite_firebase_auth_domain}
VITE_FIREBASE_PROJECT_ID={vite_firebase_project_id}
VITE_FIREBASE_STORAGE_BUCKET={vite_firebase_storage_bucket}
VITE_FIREBASE_MESSAGING_SENDER_ID={vite_firebase_messaging_sender_id}
VITE_FIREBASE_APP_ID={vite_firebase_app_id}
"""


with open("../../frontend/.env.local", "w") as env_var_file:
    env_var_file.write(env_variables)