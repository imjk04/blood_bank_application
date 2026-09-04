# blood_bank_application
# 🩸 Blood Bank Application — Jenkins CI/CD Pipeline

## 📌 Project Structure

This project is a **Blood Bank Application** developed using **PHP**.

The application provides the following functionalities:

* 👤 User account creation
* 🔐 User authentication
* 🔎 Find blood donors
* 🩸 Register/Nominate yourself for blood donation

The application is divided into two services:

### 1. Database Service

The **Database Service** handles authentication-related functionality, including:

* User account creation
* User authentication
* User account-related operations

### 2. Application Service

The **Application Service** handles the main blood bank functionalities, including:

* Finding blood donors
* Blood donation
* Donor-related operations

---

# 🏗️ Infrastructure

For this project, two servers are maintained:

### Jenkins Server

The Jenkins Server is used for:

* Jenkins installation
* CI/CD pipeline management
* Docker
* SonarQube

### Application Server

The Application Server is used for:

* Running the Jenkins pipeline
* Building Docker images
* Vulnerability scanning
* Application deployment

### Server Configuration

| Server                 | Instance Type    | Purpose                                       |
| ---------------------- | ---------------- | --------------------------------------------- |
| Jenkins Server         | `m7i-flex-large` | Jenkins, Docker, SonarQube                    |
| Application Server     | `m7i-flex-large` | Pipeline execution and application deployment |
| Application Server RAM | `28 GB`          | Application and pipeline workloads            |

---

# 🔧 Practical Setup

## 1. Jenkins Server Setup

Install the following components on the Jenkins Server:

* Java
* Jenkins
* Docker

Docker is required to run the SonarQube container.

---

## 2. Application Server Setup

Install the following components on the Application Server:

* Java
* Git
* Docker
* Docker Compose
* Trivy

**Trivy** is used to scan Docker images for security vulnerabilities.

---

# 🔗 3. Connect Jenkins to the Application Server

Connect the Jenkins Server to the Application Server using the **private IP address**.

The Application Server acts as the Jenkins node/agent where the pipeline will execute.

```text
Jenkins Server
      │
      │ Private IP
      ▼
Application Server
      │
      ├── Git
      ├── Docker
      ├── Docker Compose
      └── Trivy
```

---

# 🐳 4. SonarQube Setup

After installing Jenkins and Docker on the Jenkins Server, run the SonarQube container.

### Run SonarQube

```bash
docker run -itd \
  --name CQA \
  -p 9000:9000 \
  sonarqube:lts-community
```

SonarQube can then be accessed using:

```text
http://<JENKINS_SERVER_IP>:9000
```

### Default SonarQube Credentials

```text
Username: admin
Password: admin
```

> **Note:** Change the default password after the initial login.

---

# 🔐 5. Jenkins Plugins

Install the following Jenkins plugins.

### CI/CD Plugins

* Docker Pipeline
* Pipeline Stage View
* SonarQube Scanner

### Audit Plugins

* Audit Trail
* Audit Log
* Audit Flow

These audit plugins are useful for Jenkins administrators because multiple users may have access to the Jenkins dashboard.

They help track activities such as:

* User login
* Dashboard access
* Plugin installation
* Credential deletion
* Configuration changes
* Other administrative activities
* Source IP information, where supported by the configured audit plugin

> **Important:** Audit logs generally start recording activities after the audit plugin is installed and configured. Activities performed before installation will not normally be available.

---

# 📋 6. Verify Jenkins Audit Logs

Navigate to:

```text
Manage Jenkins
    ↓
Audit Flow Logs
```

To test the audit functionality:

1. Log in to Jenkins from another browser/session.
2. Access the Jenkins dashboard.
3. Check the Audit Flow Logs.
4. Install a plugin.
5. Check the audit logs again.
6. Verify that the plugin installation activity has been recorded.

This helps Jenkins administrators monitor user and administrative activities.

---

# 📊 7. Configure SonarQube in Jenkins

SonarQube needs to be integrated with Jenkins to perform code quality analysis.

## Step 1 — Generate SonarQube Token

After setting up the SonarQube project, generate a **SonarQube authentication token**.

The token will be used by Jenkins to authenticate with SonarQube.

## Step 2 — Add SonarQube Credentials

In Jenkins, navigate to:

```text
Manage Jenkins
    ↓
Credentials
```

Create a credential using:

```text
Kind: Secret text
```

Store the SonarQube token securely as the secret value.

## Step 3 — Configure SonarQube Installation

Navigate to:

```text
Manage Jenkins
    ↓
System
    ↓
SonarQube installations
```

Add the SonarQube server and configure the credentials created above.

## Step 4 — Configure SonarQube Scanner

Navigate to:

```text
Manage Jenkins
    ↓
Tools
```

Add/configure the **SonarQube Scanner**.

---

# 🔄 CI/CD Pipeline Stages

The Jenkins pipeline consists of the following stages:

```text
Stage 1 → Pull Source Code
     ↓
Stage 2 → SonarQube Code Analysis
     ↓
Stage 3 → Build Docker Images
     ↓
Stage 4 → Trivy Image Scan
     ↓
Stage 5 → Push Images to Docker Hub
     ↓
Stage 6 → Deploy Application
```

---

# 1️⃣ Stage 1 — Pull Source Code

Create a Jenkins **Pipeline Job**.

The first stage is responsible for pulling the source code from the Git repository.

The pipeline checks out the latest source code so that the subsequent stages can build and analyze the application.

---

# 2️⃣ Stage 2 — SonarQube Code Analysis

After pulling the source code, scan the code using **SonarQube**.

SonarQube performs static code analysis and identifies issues such as:

* Bugs
* Code smells
* Vulnerabilities
* Maintainability issues
* Other code quality problems

Review the issues reported by SonarQube and fix the identified problems in the source code.

After making the required fixes, run the analysis again to verify the improvements.

---

# 3️⃣ Stage 3 — Build Docker Images

The application consists of two components, so two Docker images are created:

1. **Database Image**
2. **Application Image**

For example, the database image can be built using:

```bash
docker build -t imjk04/bloodbank:db database
```

The `database` directory contains the Dockerfile and required database configuration.

### Docker Socket Permission

If Jenkins needs direct access to the Docker daemon, Docker socket permissions may need to be configured.

Example:

```bash
chmod 777 /var/run/docker.sock
```

> ⚠️ **Security Note:** `chmod 777 /var/run/docker.sock` gives broad access to the Docker socket and can provide root-equivalent privileges on the host. It is better to use appropriate group/permission configuration in a production environment.

Build the application image similarly:

```bash
docker build -t imjk04/bloodbank:app application
```

This completes **Stage 3**.

---

# 4️⃣ Stage 4 — Scan Docker Images Using Trivy

After building the Docker images, scan them for vulnerabilities using **Trivy**.

Example:

```bash
trivy image imjk04/bloodbank:db
```

Scan the application image as well:

```bash
trivy image imjk04/bloodbank:app
```

Trivy checks the images for known vulnerabilities in packages and dependencies.

This completes **Stage 4**.

---

# 5️⃣ Stage 5 — Push Images to Docker Hub

After successfully building and scanning the images, push them to a Docker registry.

For this project, **Docker Hub** is used as the container registry.

The Jenkins pipeline should be configured with Docker Hub credentials.

### Jenkins Configuration

Configure the Docker registry endpoint in Jenkins and provide:

```text
Registry: Docker Hub
Username: <Docker Hub Username>
Password: <Docker Hub Password>
```

Store the credentials securely in Jenkins and select the appropriate credentials while configuring the Docker registry.

The pipeline can then push the images:

```bash
docker push imjk04/bloodbank:db
docker push imjk04/bloodbank:app
```

This completes **Stage 5**.

---

# 6️⃣ Stage 6 — Deployment

The final stage is **Deployment**.

The Docker images pushed to Docker Hub are used to run the database and application containers on the Application Server.

There are two approaches for deployment:

### Option 1 — Docker Commands

The database container can be started using:

```bash
docker run -d \
  --name mysqldb \
  -p 3306:3306 \
  imjk04/bloodbank:db
```

The application container can then be started using:

```bash
docker run -itd \
  --name myapp \
  -p 1234:80 \
  --link mysqldb:mysqlcon \
  imjk04/bloodbank:app
```

The `--link` option connects the application container to the database container.

> **Note:** Docker `--link` is a legacy mechanism. For a modern deployment, a Docker network or Docker Compose is recommended.

---

# 🐳 Deployment Using Docker Compose

Instead of running individual Docker commands, Docker Compose can be used to manage both containers.

A Compose file can define:

* Database service
* Application service
* Container names
* Ports
* Networks
* Dependencies
* Environment variables

Example structure:

```text
docker-compose.yml

        ┌─────────────────┐
        │   Application   │
        │    Container    │
        └────────┬────────┘
                 │
                 │ Docker Network
                 │
        ┌────────▼────────┐
        │    Database     │
        │    Container    │
        └─────────────────┘
```

Docker Compose simplifies deployment because both services can be managed together.

Example:

```bash
docker compose up -d
```

To stop the services:

```bash
docker compose down
```

---

# 🔁 Complete Pipeline Flow

```text
                    GitHub Repository
                           │
                           ▼
                  ┌─────────────────┐
                  │     Jenkins     │
                  │      Stage 1    │
                  │   Pull Source   │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     Stage 2     │
                  │    SonarQube    │
                  │  Code Analysis  │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     Stage 3     │
                  │  Docker Build   │
                  │                 │
                  │ DB Image + App  │
                  │     Image       │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     Stage 4     │
                  │      Trivy      │
                  │  Image Scanning │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     Stage 5     │
                  │   Docker Hub    │
                  │  Push Images    │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     Stage 6     │
                  │    Deploy       │
                  │ Docker Compose  │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │  Blood Bank App │
                  │    Running      │
                  └─────────────────┘
```

---

# 🛠️ Tools & Technologies

| Technology         | Purpose                             |
| ------------------ | ----------------------------------- |
| **PHP**            | Application development             |
| **GitHub**         | Source code management              |
| **Jenkins**        | CI/CD automation                    |
| **Docker**         | Application containerization        |
| **Docker Compose** | Multi-container deployment          |
| **SonarQube**      | Code quality and static analysis    |
| **Trivy**          | Docker image vulnerability scanning |
| **Docker Hub**     | Container image registry            |
| **Java**           | Jenkins runtime                     |
| **Git**            | Source code management              |
| **Audit Plugins**  | Jenkins activity monitoring         |

---

# 🎯 Project Objective

The objective of this project is to implement a complete **CI/CD and DevSecOps pipeline** for a PHP-based Blood Bank Application.

The pipeline automates the following processes:

* Source code checkout
* Static code analysis
* Bug and code-quality identification
* Docker image creation
* Container vulnerability scanning
* Docker image publishing
* Application deployment

The setup also provides **Jenkins audit logging** to help administrators monitor user and administrative activities.
