IMAGE ?= ghcr.io/trains-io/z21-ref
TAG ?= local
Z21_VERSION ?= v0.4.3
CONTAINER ?= z21-ref

.PHONY: help build run stop

.DEFAULT_GOAL := help

help: ## Show available targets
	@echo "z21-ref — Docker image for the ZIMO Z21Posix LAN test server"
	@echo ""
	@echo "Usage: make [target] [VAR=value ...]"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE=$(IMAGE)"
	@echo "  TAG=$(TAG)"
	@echo "  Z21_VERSION=$(Z21_VERSION)"
	@echo "  CONTAINER=$(CONTAINER)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  %-8s %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker build --build-arg Z21_VERSION=$(Z21_VERSION) -t $(IMAGE):$(TAG) .

run: ## Start the simulator detached (UDP 21105)
	docker run --rm -d --name $(CONTAINER) -p 21105:21105/udp $(IMAGE):$(TAG)

stop: ## Stop and remove the simulator container
	@docker rm -f $(CONTAINER) >/dev/null 2>&1 && echo "Stopped $(CONTAINER)" || echo "No container named $(CONTAINER)"
