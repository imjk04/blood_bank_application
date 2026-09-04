# 🩸 Blood Bank Application — CI/CD & DevOps Setup

## 📌 Project Overview

This project is a **Blood Bank Application** developed using **.NET**.

The application provides the following major functionalities:

* 👤 User account creation and authentication
* 🔎 Find blood donors
* 🩸 Register/Nominate yourself as a blood donor

The application is divided into two main services:

### 1. Database Service

Handles user authentication and account-related operations.

* User registration
* User authentication
* Account management

### 2. Application Service

Handles the core blood bank functionalities.

* Finding blood donors
* Blood donation registration
* Donor-related operations

---

# 🏗️ Infrastructure Architecture

The project uses two servers:

| Server                 | Purpose                                       | Instance Type    |
| ---------------------- | --------------------------------------------- | ---------------- |
| **Jenkins Server**     | CI/CD pipeline management                     | `m7i-flex-large` |
| **Application Server** | Pipeline execution and application deployment | `m7i-flex-large` |

The **Application Server** is configured with **28 GB RAM** to support the required application, Docker containers, security scanning, and pipeline workloads.

### High-Level Architecture

```text
                    ┌──────────────────────┐
                    │      Developer       │
                    │    Pushes Code       │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       GitHub         │
                    │   Source Repository  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │    Jenkins Server    │
                    │                      │
                    │  Jenkins + Java      │
                    │  Docker              │
                    │  SonarQube           │
                    └──────────┬───────────┘
                               │
                     Private IP Connection
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Application Server  │
                    │                      │
                    │  Java               │
                    │  Git                │
                    │  Docker             │
                    │  Docker Compose     │
                    │  Trivy              │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Application / CQA   │
                    │      Pipeline        │
                    └──────────────────────┘
```

---

# 🚀 Practical Setup

## 1. Create the Jenkins Server

Create a server with the following configuration:

* **Instance Type:** `m7i-flex-large`
* Install **Java**
* Install **Docker**
* Install and configure **Jenkins**

The Jenkins server is responsible for managing and triggering the CI/CD pipeline.

---

## 2. Create the Application Server

Create a second server with the following configuration:

* **Instance Type:** `m7i-flex-large`
* **RAM:** 28 GB

Install the following tools:

* Java
* Git
* Docker
* Docker Compose
* Trivy

The Application Server is used to execute the pipeline workloads and perform application-related operations.

---

# 🔗 Connect Jenkins to the Application Server

After setting up both servers, connect the **Jenkins Server** to the **Application Server** using the application's **private IP address**.

This allows Jenkins to use the Application Server as a node/agent for running pipeline jobs.

```text
Jenkins Server
      │
      │ Private IP
      ▼
Application Server
      │
      ├── Docker
      ├── Docker Compose
      ├── Git
      └── Trivy
```

---

# 🐳 SonarQube Setup

After installing Jenkins and Docker on the Jenkins Server, run SonarQube as a Docker container.

### Run SonarQube

```bash
docker run -itd \
  --name CQA \
  -p 9000:9000 \
  sonarqube:lts-community
```

### Verify the Container

```bash
docker ps
```

SonarQube will be available on:

```text
http://<JENKINS_SERVER_IP>:9000
```

### Default Credentials

```text
Username: admin
Password: admin
```

> ⚠️ Change the default SonarQube password after the initial login.

---

# 🔧 Jenkins Configuration

Once Jenkins is installed, access the Jenkins dashboard and configure the required plugins and tools.

## Required Jenkins Plugins

Install the following plugins:

### CI/CD Plugins

* **Docker Pipeline**
* **Pipeline Stage View**
* **SonarQube Scanner**

### Audit & Monitoring Plugins

* **Audit Trail**
* **Audit Log**
* **Audit Flow**

---

# 🔍 Jenkins Audit Logging

Since the Jenkins dashboard can be accessed by multiple users, auditing is important for tracking administrative and user activities.

The audit plugins help Jenkins administrators monitor activities such as:

* User login activity
* Plugin installation
* Credential changes
* Configuration changes
* Job-related activities
* Deletion of credentials or other resources
* Other administrative actions

For example, administrators can investigate:

> **Who performed an action, what action was performed, and when it was performed.**

Depending on the plugin and configuration, additional information such as the source IP address may also be recorded.

### Important Note

Audit plugins generally start recording events **after they are installed and configured**. They do not normally provide historical audit records from before installation.

---

# 📋 Verify Audit Logs

After installing and configuring the audit plugins:

1. Go to **Manage Jenkins**
2. Open the configured **Audit Flow / Audit Logs** section
3. Access the Jenkins dashboard from another browser/session
4. Perform actions such as installing a plugin
5. Return to the audit log
6. Verify that the activities are recorded

For example:

```text
User Login
     ↓
Dashboard Access
     ↓
Plugin Installation
     ↓
Configuration Changes
     ↓
Audit Log
```

This allows Jenkins administrators to monitor activities performed by users.

---

# 📊 Configure SonarQube in Jenkins

SonarQube needs to be integrated with Jenkins so that the CI/CD pipeline can perform **code quality analysis**.

## Step 1 — Generate SonarQube Token

Log in to SonarQube and generate an authentication token.

Use the token when configuring SonarQube inside Jenkins.

---

## Step 2 — Add SonarQube to Jenkins

In Jenkins, navigate to:

```text
Manage Jenkins
    ↓
System
    ↓
SonarQube installations
```

Add the SonarQube server details.

Configure the authentication token using Jenkins credentials.

### Credential Type

Use:

```text
Secret Text
```

Store the SonarQube authentication token securely as a Jenkins credential.

---

## Step 3 — Configure SonarQube Scanner Tool

Navigate to:

```text
Manage Jenkins
    ↓
Tools
```

Add/configure the **SonarQube Scanner** installation.

This allows Jenkins pipelines to invoke the SonarQube scanner during the CI/CD process.

---

# 🔄 Overall CI/CD Flow

The expected workflow is:

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
Jenkins
    │
    ├── Checkout Source Code
    │
    ├── Build .NET Application
    │
    ├── SonarQube Code Quality Analysis
    │
    ├── Docker Build
    │
    ├── Trivy Image Scan
    │
    ├── Docker Compose / Deployment
    │
    ▼
Application Server
    │
    ▼
Running Blood Bank Application
```

---

# 🛡️ DevSecOps Components

The project incorporates several DevOps and DevSecOps tools:

| Tool               | Purpose                                |
| ------------------ | -------------------------------------- |
| **GitHub**         | Source code management                 |
| **Jenkins**        | CI/CD automation                       |
| **Docker**         | Containerization                       |
| **Docker Compose** | Multi-container application management |
| **SonarQube**      | Static code quality analysis           |
| **Trivy**          | Container image vulnerability scanning |
| **Audit Plugins**  | Jenkins activity and security auditing |
| **.NET**           | Application development framework      |

---

# 🎯 Objectives

The main objectives of this setup are:

* Automate the application build and deployment process
* Maintain a centralized Jenkins CI/CD environment
* Perform automated code quality checks using SonarQube
* Scan Docker images for vulnerabilities using Trivy
* Deploy applications using Docker
* Maintain audit logs for Jenkins activities
* Securely manage credentials and authentication tokens
* Separate CI/CD management from application execution

---

# 📝 Summary

The Blood Bank Application uses a two-server DevOps architecture consisting of a **Jenkins Server** and an **Application Server**.

Jenkins manages the CI/CD pipeline, while the Application Server executes pipeline workloads and handles application deployment. **SonarQube** is integrated for code quality analysis, **Trivy** is used for container vulnerability scanning, and Jenkins audit plugins provide visibility into administrative and user activities.

This setup provides a foundation for implementing a **secure, automated, and auditable CI/CD pipeline** for the .NET Blood Bank Application.
