
ORG = hawtio
NAMESPACE ?= hawtio
PROJECT = operator
TAG = latest

.PHONY: setup
setup:
	@echo Installing dep
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
	@echo setup complete run make build deploy to build and deploy the operator to a local cluster

.PHONY: build-image
build-image: compile build

.PHONY: build
build:
	operator-sdk build docker.io/${ORG}/${PROJECT}:${TAG}

.PHONY: compile
compile:
	go build -o=hawtio-operator ./cmd/manager/main.go

.PHONY: install
install: install-crds
	kubectl apply -f deploy/role.yaml -n ${NAMESPACE}
	kubectl apply -f deploy/role_binding.yaml -n ${NAMESPACE}

.PHONY: install-crds
install-crds:
	kubectl apply -f deploy/crds/hawtio_v1alpha1_hawtio_crd.yaml

.PHONY: run
run:
	operator-sdk up local --namespace=${NAMESPACE} --operator-flags=""

.PHONY: deploy
deploy:
	kubectl apply -f deploy/operator.yaml -n ${NAMESPACE}