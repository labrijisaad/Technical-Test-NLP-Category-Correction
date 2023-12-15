# Makefile for Project

VENV_NAME := venv

# Check if the COMSPEC environment variable is set (indicating a Windows system)
ifdef COMSPEC
    WARNING_MESSAGE :=
    DELETE_CMD := Remove-Item -Recurse -Force
    VENV_ACTIVATE := .\$(VENV_NAME)\Scripts\Activate
    POWERSHELL := powershell.exe
else
    WARNING_MESSAGE := @echo WARNING: These commands are meant to be used on Windows systems.
    DELETE_CMD := rm -rf
    VENV_ACTIVATE := source $(VENV_NAME)/bin/activate
    POWERSHELL := $(VENV_NAME)/Scripts/Activate.ps1
endif

# Project directories
DATA_RAW_DIR := data/raw
DATA_PROCESSED_DIR := data/processed
DATA_EXTERNAL_DIR := data/external
NOTEBOOKS_DIR := notebooks
DOCS_DIR := docs

# Files
README_FILE := README.md
CONFIG_FILE := config.yaml
ENV_FILE := .env
GITIGNORE_FILE := .gitignore
REQUIREMENTS_FILE := requirements.txt
GITKEEP_FILE := .gitkeep

.PHONY: init setup update clean jupyter lint test docs help

# Add a default target to print a helpful message
.DEFAULT_GOAL := help

init:
	@powershell -Command "if (-not (Test-Path '$(DATA_RAW_DIR)')) { mkdir '$(DATA_RAW_DIR)' | Out-Null; New-Item -ItemType file -Path '$(DATA_RAW_DIR)\$(GITKEEP_FILE)' -Force | Out-Null }"
	@powershell -Command "if (-not (Test-Path '$(DATA_PROCESSED_DIR)')) { mkdir '$(DATA_PROCESSED_DIR)' | Out-Null; New-Item -ItemType file -Path '$(DATA_PROCESSED_DIR)\$(GITKEEP_FILE)' -Force | Out-Null }"
	@powershell -Command "if (-not (Test-Path '$(DATA_EXTERNAL_DIR)')) { mkdir '$(DATA_EXTERNAL_DIR)' | Out-Null; New-Item -ItemType file -Path '$(DATA_EXTERNAL_DIR)\$(GITKEEP_FILE)' -Force | Out-Null }"
	@powershell -Command "if (-not (Test-Path '$(NOTEBOOKS_DIR)')) { mkdir '$(NOTEBOOKS_DIR)' | Out-Null; New-Item -ItemType file -Path '$(NOTEBOOKS_DIR)\$(GITKEEP_FILE)' -Force | Out-Null }"
	@powershell -Command "if (-not (Test-Path '$(DOCS_DIR)')) { mkdir '$(DOCS_DIR)' | Out-Null; New-Item -ItemType file -Path '$(DOCS_DIR)\$(GITKEEP_FILE)' -Force | Out-Null }"
	@echo ">>>>>> Project structure initialized successfully <<<<<<"
	@echo author: labriji saad > $(CONFIG_FILE)
	@echo # Add your environment variables here > $(ENV_FILE)
	@echo # Add files and directories to ignore in version control > $(GITIGNORE_FILE)
	@echo # Add your project dependencies here > $(REQUIREMENTS_FILE)


setup:
	$(WARNING_MESSAGE)
	@python -m venv $(VENV_NAME) && \
	$(VENV_NAME)\Scripts\activate && \
	powershell -Command "& {python -m pip install --upgrade pip; pip install -r requirements.txt}" 
	@echo ">>>>>> Environment is ready <<<<<<"

update:
	$(VENV_NAME)\Scripts\activate && pip install -r .\requirements.txt
	@echo ">>>>>> Dependencies updated <<<<<<"

clean:
	$(WARNING_MESSAGE)
	@rmdir /s /q $(VENV_NAME)
	@echo ">>>>>> Cleaned up environment <<<<<<"

jupyter:
	$(WARNING_MESSAGE)
	@$(VENV_NAME)\Scripts\activate && jupyter lab
	@echo ">>>>>> Jupyter Lab is running <<<<<<"

help:
	$(WARNING_MESSAGE)
	@echo  Available targets:
	@echo    make init           - Initialize The project's structure
	@echo    make setup          - Create a virtual environment and install dependencies
	@echo    make update         - Update dependencies in the virtual environment
	@echo    make clean          - Clean up the virtual environment and generated files
	@echo    make jupyter        - Activate the virtual environment and run Jupyter Lab