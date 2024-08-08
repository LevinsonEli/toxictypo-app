#!/bin/bash


# Script variables
APP_CONTAINER_NAME="toxictypo_app"
APP_CONTAINER_PORT="8085"
MAX_ATTEMPTS=5
INTERVAL_SEC=3


# TOXITYPO APP HEALTHCHECK
echo "Waiting for Toxictypo App to start..."

while ! nc -z $APP_IP $APP_CONTAINER_PORT && [ $MAX_ATTEMPTS -gt 0 ]; do   
  sleep $INTERVAL_SEC
  ((MAX_ATTEMPTS -= 1))
  echo "$MAX_ATTEMPTS attempts left"
done

# Final check
if ! nc -z $APP_IP $APP_CONTAINER_PORT; then
  echo "Toxictypo App has not started after $(( MAX_ATTEMPTS * INTERVAL_SEC )) seconds. Exiting..."
  exit 1
fi

echo "Toxictypo App started successfully!"
echo "Performing Tests..."


python /app/e2e_test.py "${APP_IP}:${APP_CONTAINER_PORT}"