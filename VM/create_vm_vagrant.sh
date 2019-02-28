#!/bin/bash
vagrant box list
vagrant box add ubuntu/xenial64 --force
vagrant init ubuntu/xenial64
vagrant up --debug
vagrant halt
vagrant global-status --prune
echo "Máquina Vagrant Finalizada!!"