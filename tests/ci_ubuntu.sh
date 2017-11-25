#!/bin/bash

cd /flask-uwsgi-nginx
apt-get update -y

apt-get update
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install ansible

# python setup
#apt-get install -y sudo python-dev python-pip
#pip install --upgrade pip setuptools

# for crypto tools?
#apt-get install -y libffi-dev libssl-dev

# install ansible
#pip install ansible ansible-lint

# Check the role/playbook's syntax.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --syntax-check

# Run the role/playbook with ansible-playbook.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --connection=local -vvvv --skip-tags update,copy_host_ssh_id
