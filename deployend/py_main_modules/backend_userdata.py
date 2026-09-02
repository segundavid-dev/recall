import json

recall_config = "../../recall_config.json"

with open(recall_config, "r") as var_file:
    config = json.load(var_file)

database_url = config["backend"]["database_url"]
redis_url = config["backend"]["redis_url"]
openai_api_key = config["backend"]["openai_api_key"]
llm_api_key = config["backend"]["llm_api_key"]
cloudinary_cloud_name = config["backend"]["cloudinary_cloud_name"]
cloudinary_api_key = config["backend"]["cloudinary_api_key"]
cloudinary_api_secret = config["backend"]["cloudinary_api_secret"]
firebase_service_account_json = config["backend"]["firebase_service_account_json"]
cognee_vector_db_url = config["backend"]["cognee_vector_db_url"]
cognee_graph_db_url = config["backend"]["cognee_graph_db_url"]


userdata = """
#!/bin/bash

apt update
apt remove -y docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc || true
apt install -y ca-certificates curl

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

git clone -b main https://github.com/chieoms/recall.git /home/ubuntu/recall
"""


setup = f"""
cat <<EOF > /home/ubuntu/recall/backend/.env
DATABASE_URL={database_url}
REDIS_URL={redis_url}
OPENAI_API_KEY={openai_api_key}
LLM_API_KEY={llm_api_key}
CLOUDINARY_CLOUD_NAME={cloudinary_cloud_name}
CLOUDINARY_API_KEY={cloudinary_api_key}
CLOUDINARY_API_SECRET={cloudinary_api_secret}
FIREBASE_SERVICE_ACCOUNT_JSON={firebase_service_account_json}
COGNEE_VECTOR_DB_URL={cognee_vector_db_url}
COGNEE_GRAPH_DB_URL={cognee_graph_db_url}
EOF

chown -R ubuntu:ubuntu /home/ubuntu/recall

docker compose -f /home/ubuntu/recall/backend/docker-compose.yml up -d --build
"""

with open("../infrastructure/backend_userdata.sh", "w") as userdata_file:
    userdata_file.write(f"{userdata}\n\n{setup}")
