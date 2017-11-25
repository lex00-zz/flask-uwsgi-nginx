# README.md
# Ansible Role: flask-uwsgi-nginx

This role for Ansible deploys your Flask application from a git source repository.

The role packages your Flask app as a wheel and then installs it into a virtualenv.

## Requirements

-   `.python-version` file

    This file must contain the version of python you are targeting.

-   `python setup.py bdist_wheel`

    The role will run this command.  Test ahead of time and make sure your project can build a wheel.

## Role Variables

**app_repo_url**: 'https://github.com/lex00/flask-github-jobs'
-   python repository containing flask application

**app_subfolder**: ''
-   if your project is in a subfolder in the repo, specify this here, otherwise set blank

**app_description**: 'A Flask that lists jobs from the github jobs API'
-   this will go into the system service script

**app_name**: 'flask_github_jobs'
-   app folders and service name

**app_user**: 'flask_github_jobs'
-   system user and group will both be this value

**app_domain**: 'notarealdomain.com'
-   domain that nginx will answer to

**app_module**: 'flask_github_jobs'
-   python module for uwsgi.ini

**app_callable**: 'app'
-   python callable for uwsgi.ini

**app_port**: '80'
-   service port

**app_health_ep**: '/'
-   health endpoint

**uwsgi_process_count**: '4'
-   number of uwsgi processes

**uwsgi_thread_count**: '2'
-   number of uwsgi threads

## Dependencies

None

## Example Playbook

```yml
- hosts: all
  tasks:
  - import_role:
       name: lex00.flask-uwsgi-nginx
  ```

## Python configuration

`pyenv` will be used to install the version of Python in your `.python-version` file in `/home/{{ app_user }}/.pyenv`.

A virtualenv will be placed in `/opt/{{ app_name }}/venv`.

## Uwsgi configuration

Uwsgi will be installed into the virtualenv.  No system packages for Uwsgi will be installed.

The Uwsgi config is here:

`/etc/conf/{{ app_name }}/app_name.ini`

This will be used by uwsgi to run your Flask app as a service.

-   socket file

    `/var/run/{{ app_name }}/{{ app_name }}.sock`

## Flask static assets

This role will autodiscover your static asset folders and configure them in nginx.

For this to work:
-   Put your assets in a folder called `static` in your flask app module.

-   set `static_url_path` to blank
    ```python
    app = Flask(__name__, static_url_path='')
    ```

## service management

Ubuntu 14.04 Start/Stop the Uwsgi service
```sh
sudo start {{ app_name }}
```

Ubuntu 14.04 Start/Stop Nginx
```sh
sudo start nginx
```

## logs

Logs will be placed in `/var/log/{{ app_name }}`

They will be owned by `{{ app_user }}`

## Vagrant + Galaxy Example

Create a `requirements.yml` with these contents:

```sh
---
- src: lex00.flask-uwsgi-nginx
```

The provisioner needs `galaxy_role_file` set to this.

```sh
config.vm.provision "ansible", type: "ansible_local" do |ansible|
  ansible.verbose = true
  ansible.become = true
  ansible.extra_vars = "vars.json"
  ansible.config_file = "ansible.cfg"
  ansible.galaxy_roles_path = "roles"
  ansible.galaxy_role_file = "requirements.yml"
  ansible.playbook = "playbook.yml"
end
```

## Packer + Galaxy Example

Create a `requirements.yml` with these contents:

```sh
---
- src: lex00.flask-uwsgi-nginx
```

The provisioner needs `galaxy_file` set to this.

```json
{
  "type": "ansible-local",
  "host_vars": "{{ user `vars_path` }}",
  "playbook_dir": "{{ user `ansible_path` }}",
  "playbook_paths": "{{ user `ansible_path` }}",
  "role_paths": "{{ user `ansible_path` }}/roles",
  "playbook_file": "{{ user `ansible_path` }}/playbook.yml",
  "galaxy_file": "{{ user `ansible_path` }}/requirements.yml",
  "extra_arguments": [ "--extra-vars \"@host_vars/vars.json\"" ]
}
```

## Testing with Vagrant

A `Vagrantfile` is included to help test the role locally.

Vagrant > 2.0 is required.

#### Start the Vagrant

The first time you do this, it will run Ansible.

```sh
flask-uwsgi-nginx$ vagrant up
```

The Vagrant should provision cleanly.

#### Reprovision the Vagrant

You can run the role again with:

```sh
flask-uwsgi-nginx/tests $ vagrant provision
```

## License

MIT
