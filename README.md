# Space-Invader

> Custom implementation of the space-invader game in [Processing](https://processing.org/) language.

## Requirements

- Processing language

## Start the game from source

```
make start PROCESSING_JAVA=/usr/share/processing/processing-3.5.4/processing-java
```

## Build the game

Run the following command to build the project in `dist/`
```
make build PROCESSING_JAVA=/usr/share/processing/processing-3.5.4/processing-java
```

## Commands

Makefile defines some commands to assist in development

```
$ make help
Usage: make <target>

Project commands
  help        Show this help
  start       Compile the game and start it
  build       Build the game in dist/ folder
  ide         Open project in processing IDE
```
