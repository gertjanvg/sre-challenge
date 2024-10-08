# Running the stack

## Requirements

* `minikube`
* `docker`
* `helm`

## Setting up

First start the minikube cluster

```bash
minikube start
```

Next, build the image in the `minikube` docker-env for easy image pushing/pulling.
Not production-ready, ideally you'd want to build it and store it in an image store (e.g. Harbor.io), but this works.

```bash
eval $(minikube docker-env)  # This sets the Docker env to the embedded one in minikube
docker build -t appimage .
```

### Prometheus

```bash
k create ns prometheus
```

### Installing app helm chart

See the Helm chart itself for more info. 
Simple install: 

```bash
k create ns app
helm install -n app main app  # installs a new instance `main` of the app chart in namespace app
```


