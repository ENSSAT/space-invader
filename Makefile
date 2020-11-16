PROCESSING_IDE:=/usr/share/processing/processing-3.5.4/processing
PROCESSING_JAVA:=/usr/share/processing/processing-3.5.4/processing-java
SKETCH_NAME:=space_invaders

help:
	echo "not implemented"

start:
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --run

build:
	$(PROCESSING_JAVA) --sketch=$(SKETCH_NAME)/ --output=build --build

ide:
	$(PROCESSING_IDE) $(SKETCH_NAME)/$(SKETCH_NAME).pde