#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = class_data_analysis_II
PYTHON_VERSION = 3.10
PYTHON_INTERPRETER = python

#################################################################################
# COMMANDS                                                                      #
#################################################################################


## Install Python Dependencies
.PHONY: requirements
requirements:
	$(PYTHON_INTERPRETER) -m pip install -U pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt
	



## Delete all compiled Python files
.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Lint using flake8 and black (use `make format` to do formatting)
.PHONY: lint
lint:
	flake8 class_data_analysis
	isort --check --diff --profile black class_data_analysis
	black --check --config pyproject.toml class_data_analysis

## Format source code with black
.PHONY: format
format:
	black --config pyproject.toml class_data_analysis




## Set up python interpreter environment
.PHONY: create_environment
create_environment:
	@bash -c "if [ ! -z `which virtualenvwrapper.sh` ]; then source `which virtualenvwrapper.sh`; mkvirtualenv $(PROJECT_NAME) --python=$(PYTHON_INTERPRETER); else mkvirtualenv.bat $(PROJECT_NAME) --python=$(PYTHON_INTERPRETER); fi"
	@echo ">>> New virtualenv created. Activate with:\nworkon $(PROJECT_NAME)"
	



#################################################################################
# PROJECT RULES                                                                 #
#################################################################################



#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

MARP_FILE_NAME = intro

marp_server:
	docker run --rm --init -v $$PWD:/home/marp/app -e LANG=$$LANG -p 8080:8080 -p 37717:37717 marpteam/marp-cli -s . --theme-set ./themes/*.css

pdf:
	docker run --rm --init -v $$PWD:/home/marp/app/ -e LANG=$$LANG -e MARP_USER="$$(id -u):$(id -g)" marpteam/marp-cli ./docs/slides/${MARP_FILE_NAME}.md --pdf --theme-set ./themes/*.css -o ./docs/pdf/${MARP_FILE_NAME}.pdf --allow-local-files

pdf_class1: pdf

HONKIT_FILE = introduction

honkit_pdf:
	docker run --rm -v $$PWD:/docs honkit/honkit npx honkit pdf ${HONKIT_FILE}.md ${HONKIT_FILE}.pdf


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)
