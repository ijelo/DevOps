CURRENT_DIR := $(shell pwd)

all:    build box up 

.PHONY: clean

help:
	@echo "Run make with:"
	@echo " > all            ...to create VM, box install box, run VM and login to VM"
	@echo " > validate       ...to run packer validation"
	@echo " > build          ...to start packer build"
	@echo " > up             ...to start vagrant with new box"
	@echo " > box            ...to add box to  vagrant"
	@echo " > start          ...to start vagrant node" 
	@echo " > stop           ...to stop vagrant node"
	@echo " > remove         ...to remove vagrant node"
	@echo " > reload         ...to reload vagrant"
	@echo " > ssh            ...to ssh into vm"
	@echo " > clean          ...to cleanup for next build"

validate:
	packer validate $(CURRENT_DIR)/packer.json

build:
	mkdir -p $(CURRENT_DIR)/{iso,target}
	packer build $(CURRENT_DIR)/packer.json
	cp $(CURRENT_DIR)/config/Vagrantfile.tpl $(CURRENT_DIR)/target/Vagrantfile
	cp $(CURRENT_DIR)/config/bootstrap.tpl   $(CURRENT_DIR)/target/bootstrap.sh

box:
	vagrant box add --force ijelo/c7-simple $(CURRENT_DIR)/target/c7-simple-x64-virtualbox-minimal.box

up:
	cd $(CURRENT_DIR)/target && vagrant up

start:
	cd $(CURRENT_DIR)/target && vagrant up

stop:
	cd $(CURRENT_DIR)/target && vagrant halt

remove:
	cd $(CURRENT_DIR)/target && vagrant halt
	cd $(CURRENT_DIR)/target && vagrant destroy -f

reload:
	cd $(CURRENT_DIR)/target && vagrant reload

ssh:
	cd $(CURRENT_DIR)/target && vagrant ssh

clean:
	cd $(CURRENT_DIR)/target && vagrant halt
	cd $(CURRENT_DIR)/target && vagrant destroy -f
	rm -fr $(CURRENT_DIR)/target && mkdir $(CURRENT_DIR)/target 2> /dev/null
	rm -fr $(CURRENT_DIR)/iso && mkdir $(CURRENT_DIR)/iso 2> /dev/null
	rm -fr $(CURRENT_DIR)/packer_cache  2> /dev/null
	vagrant box remove ijelo/c7-simple
