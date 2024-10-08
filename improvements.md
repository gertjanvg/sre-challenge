# Improvements and explanation

## Flask app improvements


### Password handling
First critical issue to fix is how passwords are handled; at the moment it's all plaintext.
Instead use something like `flask-bcrypt` to hash passwords and salt them.

Next, instead of fetching all users from the database (which in itself presents a vulnerability if you can access the memory from other processes/threads and leak all usernames), just do a select on the given username and check if the given password was correct.
Depending on the specific case and requirements: don't give out information on whether the user exists or not (but also 'spoof' password checking time; attacker could deduce that request returned quickly vs slowly [which indicates that hashing took place]).

### Login form CSRF token

For example, use Flask-WTF to add a CSRF token to the login form. This (partially) mitigates CSRF attacks.

### Database change
Even though only the users are stored in the database (quite terribly as well), it might be a good idea to change the database from SQlite to a scalable version, e.g. MySQL (or Galera variant), Postgres, etc.

### Logging leaks

At the moment things are being logged in the application that should never be logged, e.g. plaintext passwords.
If logs are accessed by a malicious party we can recover a lot of information.

So, best would be to limit the information we log.

## Configuration

* Want to configure the `SECRET_KEY` of the Flask application not in-code, but e.g. load it in from a file that's configured in the K8s deployment and mounted as file from a secret.
* Some options may be SealedSecret to keep secret in version control; or something like HashiCorp Vault, also providing key rotation mechanisms.

## Dockerfile

* Use simple alpine image for small images. Might introduce issues when using clib6 specific things.
* Considering there's no need for building, we use one straight image instead of multi-stage builds for smaller images.
* Use `gunicorn` for serving requests rather than the Flask built-in WSGI server for faster and more secure serving. Alternative might be `uvicorn` when using ASGI.

## Helm chart

* Use default Helm chart created by `helm create`, configure image and ports.
* Quite simple to use, extendable when adding things like database or more dependent services.

## Cluster setup

Use `kube-prometheus` to enable metrics collection on the cluster. 
Automatically logs and stores cluster metrics + includes useful alerts which are viewable in Grafana.

## Logging

> Note: Not implemented/tested

There are a couple different ways to handle logging in the cluster. 
First, make a distinction between the types of logs we want to store.
For example, logs of `kubelet` might not be important (unless there are security implications) for long term storage, so we keep them for e.g. 14 days.

Other logs, however, might be more important business-wise (depending on requirements). 

### Fluentbit + ELK

One way to store logging data is to run `fluentbit` as a DaemonSet on the nodes, which collects logs, enriches them (in some way) and sends them on their way to an ELK (ElasticSearch-Logstash-Kibana) stack.
This way logs are indexed and easily searched.

A way to orchestrate the ELK stack is via the ECK (Elastic Cloud on Kubernetes) Operator. 
Configuration can be put in Elastic on how long you want logs to last, when they should be rolled over and archived in cool storage etc.



