apt-get update -y -qq
apt-get install python-pip
pip install ansible ansible-lint

# Check the role/playbook's syntax.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --syntax-check

# Run the role/playbook with ansible-playbook.
ansible-playbook -i tests/inventory --extra-vars="@tests/test.json" tests/test.yml --connection=local -vvvv --skip-tags update,copy_host_ssh_id
