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
Even though only the users are stored in the database (quite terribly as well), it might be a good idea to change the database from SQlite (which )


## Configuration

* Want to configure the `SECRET_KEY` of the Flask application not in-code, but e.g. load it in from a file that's configured in the K8s deployment and mounted as file from a secret.


## Dockerfile

* 

