#  Blue-Green Deployment of multicontainer-todo-app

This repository demonstrates a **Blue-Green Deployment strategy** for a multi-container Node.js application with MongoDB.
The deployment is automated via **GitHub Actions**, with **Nginx** acting as a traffic switch, ensuring **zero downtime deployments**.

## Features

- Blue-Green deployment using Docker Compose
- Seamless switching of traffic with Nginx
- CI/CD automation with GitHub Actions
- Safe deployments with health check option before traffic switch
- Deployed on AWS EC2 (or any Linux VM)
- Add Prometheus for monitoring

##  Directory Structure
```
blue-green-todo-deploy/
├── docker-compose.yml         # Blue-Green app + Mongo + Nginx
├── nginx.conf                 # Reverse proxy to switch traffic
├── .env.example               # Sample environment file
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions CI/CD
├── health-check.sh            # Optional: script to test new version
└── README.md
```
## Prerequisites

- Docker & Docker Compose installed on server
- EC2 instance with port **80** open in the security group
- SSH access using a private key (used in GitHub secret)

##  How It Works

- `app-blue` runs the current version on port **3000**
- `app-green` is the upcoming version, isolated on port **3001**
- Nginx listens on **port 80** and proxies requests to `app-blue` or `app-green`
- GitHub Actions triggers a new deployment:
  - Builds new app version
  - Runs `app-green`
  - Runs health check
  - Switches Nginx config
  - Stops `app-blue`

## Steps to setup and deploy

### 1.Clone this repo on the server:
```
git clone https://github.com/suchithrachandrasekaran/blue-green-todo-deploy.git
cd blue-green-todo-deploy
```
### 2.Start Blue Deployment

      docker-compose up -d app-blue mongo nginx

Blue app will be active at http://ec2-ip

### 3.Add and Verify Green Version

      docker-compose up -d app-green

Verify at http://ec2-ip:3001 

### 4.Switch Traffic to Green

Edit nginx.conf:
```
upstream backend {
    server app-green:3000;
}
```
Then reload Nginx:

      docker-compose restart nginx
### 5.Stop Blue (Optional)

      docker-compose stop app-blue
### 6. CI/CD with GitHub Actions
When code is pushed:
- GitHub builds and pushes new version
- SSH into EC2 instance
- Starts green container
- Runs health-check (optional)
- Updates Nginx config
- Restarts Nginx, stops blue
