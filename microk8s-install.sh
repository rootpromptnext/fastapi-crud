#!/bin/bash
set -e

sudo snap install microk8s --classic

sudo usermod -aG microk8s $USER
sudo chown -f -R $USER ~/.kube || true

sudo microk8s status --wait-ready

sudo microk8s enable dns storage

sudo snap alias microk8s.kubectl kubectl

sudo microk8s kubectl config view --raw > ~/.kube/config
sudo chmod 600 ~/.kube/config

echo "Please log out and log back in so group changes take effect."
echo "Then test with: kubectl get nodes"
