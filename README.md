# 🚀 Entry Trucker (Flask & MySQL using Docker on CI/CD to AWS)

This project is a **Flask-based web application** that logs requests into a MySQL database and exposes an API endpoint. It is fully containerized using Docker and integrated with **GitHub Actions CI/CD**, including versioned builds and deployment to **AWS ECR & EC2**.

---

## 📌 Features

- Logs hostname, IP address, and timestamp on every request
- Flask app served via Docker
- GitHub Actions CI for:
  - Semantic versioning and tagging
  - Building and testing the image
  - Running E2E tests via Docker Compose
  - Pushing versioned images to AWS ECR
  - Deploying to EC2 via SSH using Docker Compose

---

## 🐳 Docker Usage

### Build & Run Manually

```bash
docker build -t entry-trucker .
docker run -p 5000:5000 entry-trucker
```

### Docker Compose

```bash
docker-compose up --build
```

---

## ✅ CI/CD Workflow (GitHub Actions)

### 1. Build & Version

- Fetches the latest git tag and bumps the patch (e.g., `v1.0.3`)
- Tags and pushes it to the repository

### 2. Build & Validate

- Builds Docker image with semantic versioning
- Runs the container
- Performs a curl request to validate the running app
- Saves the image as an artifact

### 3. E2E (via Docker Compose)

- Downloads the image artifact
- Loads it into Docker
- Starts the app using `docker-compose`
- Verifies the endpoint with `curl`
- Tears down the environment

### 4. Push to AWS ECR

- Authenticates to ECR
- Tags the Docker image using the new version
- Pushes the image to your ECR repo:
  ```bash
  docker tag entry-trucker:v1.0.3 884394270539.dkr.ecr.ap-south-1.amazonaws.com/development/entry-trucker:v1.0.3
  docker push 884394270539.dkr.ecr.ap-south-1.amazonaws.com/development/entry-trucker:v1.0.3
  ```

### 5. Deploy to EC2

- Connects to EC2 via SSH
- Logs into ECR from the EC2 machine
- Pulls the latest image
- Updates `.env` with the new version:
  ```env
  VERSION=v1.0.3
  ```
- Runs:
  ```bash
  docker compose down
  docker compose pull
  docker compose up -d
  ```

---

## 📁 Project Structure

```
.
├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── .env
├── .github/
│   └── workflows/
│       └── ci.yml
└── README.md
```

---

## 🔐 Secrets Required (GitHub Actions)

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `EC2_HOST`
- `EC2_USER`
- `EC2_SSH_KEY` (private key contents)

---

## 🛠️ Requirements on EC2 Instance

- Docker & Docker Compose installed
- AWS CLI installed
- `.env` file with a `VERSION` variable
- Directory structure matching GitHub repo

---

## 🔄 Auto Versioning

Semantic versioning is handled by checking the latest git tag and incrementing the patch version automatically in the CI workflow.

---

## ✅ Endpoint

Once deployed:
```bash
curl http://<EC2_PUBLIC_IP>:5000
```
Should return:
```json
{
  "ip": "...",
  "hostname": "...",
  "timestamp": "..."
}
```
