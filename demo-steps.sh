# These are just ideas of things to try in Kubernetes
# - don't just run the whole script in one go!

# Start minikube, in a way suitable for accessing from internet
minikube start --vm-driver=none

# Start the hello application (version 1.0.1) as a deployment (single pod)
kubectl create deployment hello --image=hello:1.0.0

# Find out about the deployment
kubectl get deployments -o wide

# Find out about the pod(s)
kubectl get pods -o wide

# Find out about services
kubectl get services -o wide

# Access the pod via its IP address (within the cluster) -- MIGHT BE DIFFERENT!
curl http://172.17.0.3:8000

# Scale the application to run inside 3 x pods
kubectl scale deployment hello --replicas=3

# Review...
kubectl get deployments -o wide
kubectl get pods -o wide

# Access individual pods via cluster IP address
curl http://172.17.0.3:8000
curl http://172.17.0.4:8000
curl http://172.17.0.5:8000

# Expose the application pods as single service, with one IP address (cluster-IP)
kubectl expose deployment hello --name=hello-service --port=80 --target-port=8000

# Review...
kubectl get pods -o wide
kubectl get services

# Access hello service using its cluster IP -- MAY BE DIFFERENT!
curl http://X.X.X.X

# Look at the logs from the hello service (picks one pod)
kubectl logs deployment/hello

# Use STERN to combine logs from all pods in service
stern hello

# Redeploy the newer version of the hello image (1.0.1)
kubectl set image deployment/hello hello=hello:1.0.1

# Check versions of image used for deployment
kubectl get deployments -o wide

# Access hello service using its cluster IP -- MAY BE DIFFERENT!
curl http://X.X.X.X

# View the rollout history
kubectl rollout history deployment/hello

# View the rollout history, for specific revision
kubectl rollout history deployment/hello --revision=2

# Roll back to earlier deployment
kubectl rollout undo deployment/hello

# Access hello service using its cluster IP -- MAY BE DIFFERENT!
curl http://X.X.X.X

# Deploy the consumer web service (it calls the hello service using http://hello-service - see code)
kubectl create deployment hello-consumer --image=hello-consumer:1.0.0

# Create a cluster IP for the hello-consumer service
kubectl expose deployment hello-consumer --name=hello-consumer-service --port=80 --target-port=8000

# Access the consumer service (via cluster IP)
kubectl get services
curl http://X.X.X.X

# Simulate the consumer being unable to call the hello service
kubectl scale deployment hello --replicas=0
# Should see reply from consumer saying couldn't contact hello service
curl http://X.X.X.X

# Make it work again
kubectl scale deployment hello --replicas=3

# Expose consumer service thorugh a (simulated) load balancer
kubectl expose service hello-consumer-service --name=hello-service-lb --type=LoadBalancer --port=80 --target-port=80

# Review...
kubectl get services

# Access the consumer service (via load balancer within cluster)
curl http://X.X.X.X

# Access consumer service (via port exposed to internet)
# NB: Need to find out random port allocated, and open that port in AWS EC2 security group
# Then access via EC2 public IP + this random port number
curl http://X.X.X.X:PPPPP



# Get rid of entire minikube cluster
minikube delete