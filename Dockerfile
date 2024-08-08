# FROM maven:3.8.4-jdk-8 AS build
# COPY . /app
# WORKDIR /app
# RUN mvn verify

FROM eclipse-temurin:8u412-b08-jre-alpine
COPY . /app
WORKDIR /app
EXPOSE 8085

ENTRYPOINT ["java", "-jar", "/app/target/toxictypoapp-1.0-SNAPSHOT.jar"]