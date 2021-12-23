ENVIRONMENT ?= "dev"
DOCKER_REPO ?= 937396830441.dkr.ecr.ap-south-1.amazonaws.com/pythonapp
GIT_COMMIT_HASH_SHORT ?= ""
DOCKER_IMG ?= $(DOCKER_REPO):$(ENVIRONMENT)-$(GIT_COMMIT_HASH_SHORT)


all: build push

default: build

login:
	aws --region ap-south-1 ecr get-login-password | docker login --username AWS --password-stdin 937396830441.dkr.ecr.ap-south-1.amazonaws.com

build:
	docker build \
		--no-cache=true \
		--force-rm \
		--network=host \
		-t $(DOCKER_IMG) \
		-t $(DOCKER_REPO):$(ENVIRONMENT)-latest .

push:
	docker push $(DOCKER_IMG)
	docker push $(DOCKER_REPO):$(ENVIRONMENT)-latest

replace:
	sed -e "s/%GIT_COMMIT_HASH_SHORT%/${GIT_COMMIT_HASH_SHORT}/g; s/%ENVIRONMENT%/${ENVIRONMENT}/g; s/%REPLICA_COUNT%/${REPLICA_COUNT}/g; s/%NAMESPACE%/${NAMESPACE}/g;" infra/eks/deployment.yml > infra/eks/deployment-${ENVIRONMENT}.yml

ls list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: login build cache-build push ls list