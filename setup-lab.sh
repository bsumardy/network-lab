#!/bin/bash

# Exit immediately on error
set -e

echo "🛠️ Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing base packages..."
sudo apt install -y curl wget git unzip net-tools htop gnupg ca-certificates python3-pip python3-venv software-properties-common

echo "🐳 Removing Snap Docker if installed..."
sudo snap remove docker || true

echo "🐳 Installing Docker from official repo..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu noble stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔧 Enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "🔌 Installing Containerlab..."
bash -c "$(curl -sL https://get.containerlab.dev)"

echo "🐟 Pulling Batfish Docker image..."
docker pull batfish/batfish

echo "🐍 Installing Ansible via pip..."
pip3 install --user ansible

echo "✅ Setup complete! Please log out and back in (or reboot) for group changes to apply."
