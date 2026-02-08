#!/bin/bash

docker_file="php-Dockerfile"
image_name="my-php-fpm"

deployment_file="php-fpm-deployment.yaml"
deployment_name="php-fpm-deployment"

echo "Switching docker env to minikube"
eval "$(minikube docker-env)"

echo "Building image ..."
docker build -f "${docker_file}" -t "${image_name}" .

echo "Deploying to Kubernetes"
kubectl apply -f "${deployment_file}"


echo "Restarting deployment"
kubectl rollout restart "deployment/${deployment_name}"
kubectl rollout status "deployment/${deployment_name}"

echo "Done !!!"
