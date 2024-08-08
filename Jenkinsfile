pipeline {
  agent any

  tools {
    maven 'MavenTool'
    jdk 'OracleJDK8'
  }

  environment {
    SETTINGS_XML_ID = 'artifactory_settings_xml'
    CREDENTIALS_ID = 'artifactory_admin_credentials'
    SSH_CREDENTIALS_ID = 'ssh_to_gitlab'
    GIT_URL = 'git@gitlab.com:jenkins1444027/toxic_typo_app.git'
    JAVA_HOME = tool name: 'OracleJDK8', type: 'jdk'

    PERSONAL_ACCESS_TOKEN_ID = 'Personal_GitLab_Access_Token'
    REGISTRY_URL = 'registry.gitlab.com'
    REGISTRY_USERNAME = 'eliyahulevinson@gmail.com'
    REGISTRY_PROJECT_URL = 'registry.gitlab.com/jenkins1444027/suggest-lib'
  }

  stages {
    stage('Checkout') {
      when {
        anyOf {
          branch "feature/*"
          branch "master"
        }
      }
      steps {
        script {
          git branch: "${env.GIT_BRANCH}", credentialsId: "${env.SSH_CREDENTIALS_ID}", url: "${env.GIT_URL}"
        }
      }
    }

    stage('Build') {
      when {
        anyOf {
          branch "feature/*"
          branch "master"
        }
      }
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            configFileProvider([configFile(fileId: "${SETTINGS_XML_ID}", variable: 'SETTINGS_XML_FILE')]) {
              sh """
                mvn clean package -U --batch-mode -s ${SETTINGS_XML_FILE} -Dmaven.test.skip=true -Dusername=${USERNAME} -Dpassword=${PASSWORD}
                mvn clean deploy -U --batch-mode -s ${SETTINGS_XML_FILE} -Dmaven.test.skip=true -Dusername=${USERNAME} -Dpassword=${PASSWORD}
              """
            }
          }
        }
      }
    }

    stage('E2E Test') {
      when {
        anyOf {
          branch "feature/*"
          branch "master"
        }
      }
      steps {
        script {
          sh "docker rm -f toxictypo_app || true && docker run -d --name toxictypo_app -p 8085:8080 toxictypoapp:1.0-SNAPSHOT"
          def APP_CONTAINER_IP = sh(script: 'docker inspect -f "{{ .NetworkSettings.Networks.bridge.Gateway }}" toxictypo_app', returnStdout: true).trim()
          println APP_CONTAINER_IP
          sh """
            docker build -t toxictypo_tests -f Dockerfile.tests .
            docker rm toxictypo_tests || true && docker run --name toxictypo_tests -p 5001:5000 -e APP_IP=$APP_CONTAINER_IP toxictypo_tests
          """
        }
      }
    }

    stage('Deploy to AWS') {
      when {
        anyOf {
          branch "master"
        }
      }
      steps {
        script {
          withCredentials(
            [string(credentialsId: "${env.PERSONAL_ACCESS_TOKEN_ID}", variable: 'TOKEN')]
          ) {
            def tag = "latest"
            sh """
              echo "${TOKEN}" | docker login "${env.REGISTRY_URL}" -u "${env.REGISTRY_USERNAME}" --password-stdin
              docker build -t "${env.REGISTRY_PROJECT_URL}:${tag}" .
              docker push "${env.REGISTRY_PROJECT_URL}:${tag}"
            """
          }
        }
      }
    }
  }

  post {
    success {
      emailext body: "Your last build successed",
      subject: "SUCCESS",
      to: "${env.REGISTRY_USERNAME}"
    }

    failure {
      emailext body: "Your last build failed",
      subject: "FAILURE",
      to: "${env.REGISTRY_USERNAME}"
    }
  }
}
