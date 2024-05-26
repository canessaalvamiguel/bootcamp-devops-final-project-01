# Jenkins Setup on GCP

This README file contains instructions and scripts for setting up Jenkins on a Google Cloud Platform (GCP) Virtual Machine (VM) using a Bitnami package, installing necessary tools and plugins, and configuring Jenkins for continuous integration and delivery (CI/CD) pipelines.
It includes steps for integrating deployment to Google Kubernetes Engine (GKE) using Google Container Registry.

## Prerequisites

1. **Google Cloud Platform (GCP) Account**: Ensure you have a GCP account with necessary permissions to create VMs and manage networking and IAM roles.
2. **GitHub Repository**: A GitHub repository to connect with Jenkins for CI/CD.

## Steps

### 1. Create a VM in GCP

Create a VM using the Bitnami Jenkins package. Once completed you can copy the credentials from `Custom metadata section`.

### 2. Reserve a Static IP for Jenkins

Reserve a static IP address in GCP and assign it to the Jenkins VM.

### 3. Install Docker

Follow the steps in the [Docker documentation](https://docs.docker.com/engine/install/debian/) to install Docker on your VM. Ensure Docker is set up to run as a non-root user by following the steps [here](https://docs.docker.com/engine/install/linux-postinstall/).

### 4. Install `kubectl`

Run the following commands to install `kubectl`:

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt-get update
sudo apt-get install -y kubectl
```

### 5. Install Google Cloud SDK GKE Auth Plugin

Install the Google Cloud SDK GKE auth plugin using:

```bash
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
```

### 6. Install Jenkins Plugins

Install the following plugins in Jenkins:

- [Google Kubernetes Engine](https://plugins.jenkins.io/google-kubernetes-engine/)
- [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/)
- [Pipeline: Stage View](https://plugins.jenkins.io/pipeline-stage-view/)
- [GitHub](https://plugins.jenkins.io/github/)

### 7. Create a Service Account in GCP

Create a service account in GCP and assign the following roles:

- `Artifact Registry Administrator`
- `Kubernetes Engine Cluster Administrator`
- `Artifact Registry Repository Administrator` for pushes with creations
- `Editor`

Download the JSON credentials for the service account.

### 8. Create Secrets in Jenkins

Create the following secrets in Jenkins using the downloaded JSON credentials:

- Google Kubernetes Engine Secret: `sa-kubectl`, type: `Google Service Account from private key`
- GCP Deployer Secret: `gcp-deployer`, type: `Secret file`

### 9. Add Jenkins User to Docker Group

Run the following command to add the Jenkins user to the Docker group:

```bash
sudo usermod -a -G docker jenkins
```
Restart the Jenkins server after this change.

### 10. Create a GitHub Webhook
Create a webhook in your GitHub repository for push events. Use the following URL:

```bash
http://<server-ip>/github-webhook/
```

### 11. Configure Jenkins Pipeline

When creating a pipeline in Jenkins:

- Select the checkbox for `GitHub hook trigger for GITScm polling` in the `Build Triggers section`.
- In the Pipeline configuration, select `Pipeline script from SCM`.
- Choose `Git` in the `SCM section`.
- Set the Repository URL to the GitHub repository URL ending in .git.
- Set the Branch Specifier to `main`.
- Unselect `Lightweight checkout`.