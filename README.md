# 🚀 Entry Trucker (Flask & MySQL using  Docker on CI/CD)

This project is a **Flask-based web application** that logs requests into a MySQL database and exposes an API endpoint. It is fully containerized using Docker and integrated with **GitHub Actions CI/CD**, including Docker-based validation and deployment to **AWS ECR**.

---

## 📌 Features

- Logs hostname, IP address, and timestamp on every request
- Flask app served via Docker
- GitHub Actions CI for:
  - Building the image
  - Running the container and validating with curl
  - Running the app with Docker Compose
  - Pushing versioned images to AWS ECR

---

## 🏃‍♂️ Run Locally (Without Docker)

```bash
pip install -r requirements.txt
python app.py
```

Visit: [http://localhost:5000](http://localhost:5000)

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

### 1. Build & Validate

- Builds Docker image with a version tag
- Runs the container
- Performs a curl request to ensure the app responds

### 2. E2E (via Docker Compose)

- Starts the app using `docker-compose`
- Uses `curl` to verify it's running

### 3. Push to AWS ECR

- Logs into ECR:

  ```bash
  aws ecr get-login-password --region ap-south-1 \
    | docker login --username AWS --password-stdin 884394270539.dkr.ecr.ap-south-1.amazonaws.com
  ```

- Build, tag, and push:
  ```bash
  docker build -t development/entry-trucker .
  docker tag development/entry-trucker:latest 884394270539.dkr.ecr.ap-south-1.amazonaws.com/development/entry-trucker:latest
  docker push 884394270539.dkr.ecr.ap-south-1.amazonaws.com/development/entry-trucker:latest
  ```

---

## 📁 Project Structure

```
.
├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── .github/
│   └── workflows/
│       └── ci.yml
└── README.md
```

---
