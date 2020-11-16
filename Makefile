PROCESSING_IDE:=/usr/share/processing/processing-3.5.4/processing
PROCESSING_JAVA:=/usr/share/processing/processing-3.5.4/processing-java
SKETCH_NAME:=space_invaders

.PHONY: build

##@ Project commands
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

start: ## Compile the game and start it
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --run

build: ## Build the game in dist/ folder
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --force --output=build --build

ide: ## Open project in processing IDE
	$(PROCESSING_IDE) $(SKETCH_NAME)/$(SKETCH_NAME).pde