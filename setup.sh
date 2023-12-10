#!/bin/bash

# install git
yum install -y git

# install tfenv
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile

#install aws-cli
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# ./aws/install

#install graphviz
yum install graphviz

aws s3 cp s3://cloud-private/config/.aws/config /root/config
aws s3 cp s3://cloud-private/config/.aws/credentials /root/credentials


# aws s3api put-object --bucket cloud-private --key config/.aws/config --body ~/.aws/config
# aws s3api put-object --bucket cloud-private --key config/.aws/credentials --body ~/.aws/credentials

aws s3api put-object --bucket cloud-private --key graph.png --body graph.png
aws s3 cp s3://cloud-private/graph.png graph.png


#install docker
sudo dnf install -y docker
sudo usermod -aG docker ec2-user

#start docker
sudo systemctl enable --now docker

#install docker compose
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

#潘多拉 (Pandora)
docker pull pengzhile/pandora

#start chatgpt service
docker run  -e PANDORA_CLOUD=cloud -e PANDORA_SERVER=0.0.0.0:8899 -p 8899:8899 -d pengzhile/pandora


