# toxictypo-app

## Overview

`toxictypo-app` is a Java app that suggests for the closest word on users input string. This project uses Jenkins pipeline to automate the CI/CD process, JFrog Artifactory to sotre the mvn dependencies, Docker & Docker Compose for building and deploying the app to AWS EC2 instance with additional ALB. A huge part of the functionality was implemented through Jenkins plugins and 'tools'.

**#Docker #DockerCompose #MVN #Jenkins #JFrog #Artifactory #AWS #EC2 #ALB #CI/CD #DependencyManagement**

![Diagram](architecture.png)

## CI/CD Pipeline Flow:

### 1. For branch `master`:
- Checkout 
- Build
- E2E Tests
- AWS Deploy

### 2. For branch `feature/*`:
- Checkout 
- Build
- E2E Tests
