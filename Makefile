VIRTUALENV=.venv

.PHONY: build upload lint clean help

help:
	@echo "These are our make targets and what they do."
	@echo "All unlisted targets are internal."
	@echo ""
	@echo "  help:      Show this helptext"
	@echo "  build:     Create the distributions which we like to upload to pypi"
	@echo "  lint:      Lint the code"
	@echo "  upload:    [build], but also upload to pypi using twine"
	@echo "  clean:     Remove typically unwanted files, mostly from [build]"


$(VIRTUALENV):
	virtualenv $(VIRTUALENV)
	$(VIRTUALENV)/bin/pip install --upgrade pip
	$(VIRTUALENV)/bin/pip install --upgrade setuptools
	$(VIRTUALENV)/bin/python setup.py develop


build: $(VIRTUALENV)
	$(VIRTUALENV)/bin/python setup.py sdist bdist_egg


$(VIRTUALENV)/bin/twine: $(VIRTUALENV)
	$(VIRTUALENV)/bin/pip install -U twine==1.9.1

upload: $(VIRTUALENV)/bin/twine build
	$(VIRTUALENV)/bin/twine upload dist/*


$(VIRTUALENV)/bin/flake8: $(VIRTUALENV)
	$(VIRTUALENV)/bin/pip install -U flake8==3.5.0
	touch $(VIRTUALENV)/bin/flake8

lint: $(VIRTUALENV)/bin/flake8
	$(VIRTUALENV)/bin/flake8


clean:
	-rm -rf $(VIRTUALENV)
	-rm -rf dist
	-rm -rf build
	-rm -rf *.egg-info
