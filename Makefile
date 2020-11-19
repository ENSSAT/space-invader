PROCESSING_IDE:=/usr/share/processing/processing-3.5.4/processing
PROCESSING_JAVA:=/usr/share/processing/processing-3.5.4/processing-java
SKETCH_NAME:=space_invaders
BUILD_DIR:=build
DIST_DIR:=dist

.PHONY: build dist

##@ Project commands
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

start: ## Compile the game and start it
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --run

clear: ## Clear build and dist folders
	rm -rf $(BUILD_DIR) $(DIST_DIR)

build: ## Build the game in dist/ folder
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --output=$(BUILD_DIR) --build --force

dist: clear build ## Create distribuables for targeted platforms
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --output=$(DIST_DIR)/windows --export --platforms=windows
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --output=$(DIST_DIR)/linux --export --platforms=linux

ide: ## Open project in processing IDE
	$(PROCESSING_IDE) $(SKETCH_NAME)/$(SKETCH_NAME).pde