# README.md
# Ansible Role: flask-uwsgi-nginx

This role for Ansible deploys your Flask application from a git source repository.

The role packages your Flask app as a wheel and then installs it into a virtualenv.

## Requirements

-   `.python-version` file

    This file must contain the version of python you are targeting.

-   `python setup.py bdist_wheel`

    The role will run this command.  Test ahead of time and make sure your project can build a wheel.

## Python configuration

`pyenv` will be used to install the version of Python in your `.python-version` file in `/home/{{ app_user }}/.pyenv`.

A virtualenv will be placed in `/opt/{{ app_name }}/venv`.

## Uwsgi configuration

Uwsgi will be installed into the virtualenv.  No system packages for Uwsgi will be installed.

The Uwsgi config is here:

`/opt/{{ app_name }}/app_name.ini`

This will be used by systemd to run your Flask app as a service.

-   socket file

    `/var/run/{{ app_name }}/{{ app_name }}.sock`

-   pid file

    `/var/run/{{ app_name }}/{{ app_name }}.pid`

## service management

Start/Stop the Uwsgi service
```sh
sudo systemctl start {{ app_name }}
```

Start/Stop Nginx
```sh
sudo systemctl start nginx
```

## logs

Logs will be placed in `/var/log/{{ app_name }}`

They will be owned by `{{ app_user }}`

## Example Playbook

```yml
- hosts: all
  tasks:
  - import_role:
       name: flask-uwsgi-nginx
    vars:
      # python repository containing flask application
      app_repo_url: 'https://github.com/lex00/nublar'

      # if your project is in a subfolder in the repo, specify this here, otherwise set blank
      app_subfolder: 'python/flask'

      # this will go into the system service script
      app_description: 'A nublar example in Flask'

      # app folders and service name
      app_name: 'nublar'

      # system user and group will both be this value
      app_user: 'nublar'

      # domain that nginx will answer to
      app_domain: 'notarealdomain.com'

      # python module for uwsgi.ini
      app_module: 'nublar_example_python_flask'

      # python callable for uwsgi.ini
      app_callable: 'app'

      # service port
      app_port: '80'

      # health endpoint
      app_health_ep: '/'

      # number of uwsgi processes
      uwsgi_process_count: '10'
  ```

  ## License

  MIT
