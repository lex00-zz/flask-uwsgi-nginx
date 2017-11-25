#!/bin/bash

cd /flask-uwsgi-nginx
apt-get update -y

apt-get install -y sudo software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible

# Check the role/playbook's syntax.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --syntax-check

# Run the role/playbook with ansible-playbook.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --connection=local -vvvv --skip-tags update,copy_host_ssh_id
