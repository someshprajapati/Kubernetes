docker build -t someshprajapati/multi-client:latest -t someshprajapati/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t someshprajapati/multi-server:latest -t someshprajapati/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t someshprajapati/multi-worker:latest -t someshprajapati/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push someshprajapati/multi-client:latest
docker push someshprajapati/multi-server:latest
docker push someshprajapati/multi-worker:latest

docker push someshprajapati/multi-client:$SHA
docker push someshprajapati/multi-server:$SHA
docker push someshprajapati/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=someshprajapati/multi-server:$SHA
kubectl set image deployments/client-deployment client=someshprajapati/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=someshprajapati/multi-worker:$SHA