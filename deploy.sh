#!/usr/bin/env bash
# Build and tag the container images. Use two tags:
# 1. tag it as the latest
# 2. tag it with the git commit hash from which we're building - we need this
#    so that kubernetes will realize the config has changed to use a new image
#    and re-deploy the pods; using the git sha is also useful for debugging
#    since you'll know what commit the code in the container is using.
docker build -t mriedem/multi-client:latest \
-t mriedem/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t mriedem/multi-server:latest \
-t mriedem/multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t mriedem/multi-worker:latest \
-t mriedem/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# Push images to docker hub.
docker push mriedem/multi-client:latest
docker push mriedem/multi-server:latest
docker push mriedem/multi-worker:latest

docker push mriedem/multi-client:$GIT_SHA
docker push mriedem/multi-server:$GIT_SHA
docker push mriedem/multi-worker:$GIT_SHA

# Apply k8s config.
kubectl apply -f k8s

# Imperatively set latest images on each deployment.
kubectl set image deployments/client-deployment client=mriedem/multi-client:$GIT_SHA
kubectl set image deployments/server-deployment server=mriedem/multi-server:$GIT_SHA
kubectl set image deployments/worker-deployment worker=mriedem/multi-worker:$GIT_SHA
