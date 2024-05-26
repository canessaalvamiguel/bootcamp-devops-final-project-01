1. Create an VM in GCP using Bitnami package for Jenkins user: user passoword: aa.2uZQdXdki
2. Reservar un ip estatica para jenkins, y asignarla

3. Install docker:
Folow steps from: https://docs.docker.com/engine/install/debian/
Folow steps to use docker as non root user: https://docs.docker.com/engine/install/linux-postinstall/

4. Install kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt-get update
sudo apt-get install -y kubectl

5. Install using "apt-get install" for DEB based systems
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

6. Install Plugin in jenkins:
Google Kubernetes Engine: https://plugins.jenkins.io/google-kubernetes-engine/
Docker pipelines: https://www.jenkins.io/doc/book/pipeline/docker/

7. Create secret for Google Kubernetes Engine


