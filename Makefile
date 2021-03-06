.PHONY: build

MODULE:=txwebbackendbase

all: dev style requirements checks build dists test-unit

dev:
	pipenv install --dev

dev-py2:
	pipenv install --dev --two

install-local:
	pipenv install

install-system:
	pipenv install --system

style: isort autopep8 yapf

isort:
	pipenv run isort -y

autopep8:
	pipenv run autopep8 --in-place --recursive setup.py $(MODULE)

yapf:
	pipenv run yapf --style .yapf --recursive -i $(MODULE)

checks: flake8 pylint

flake8:
	pipenv run python setup.py flake8

pylint:
	pipenv run pylint --rcfile=.pylintrc --output-format=colorized $(MODULE)

build: dists

shell:
	@echo "Shell"
	pipenv shell

test-unit:
	pipenv run pytest $(MODULE)

test-coverage:
	pipenv run py.test -v --cov $(MODULE) --cov-report term-missing

dists: requirements sdist bdist wheels

sdist:
	pipenv run python setup.py sdist

bdist:
	pipenv run python setup.py bdist

wheels:
	@pipenv run python setup.py bdist_wheel

release: requirements

pypi-publish: build
	@echo "Publishing to Pypy"
	pipenv run python setup.py upload -r pypi

update:
	pipenv update

requirements:
	pipenv run pipenv_to_requirements

githook:style

push: githook requirements
	git push origin --tags

clean:
	pipenv --rm

# aliases to gracefully handle typos on poor dev's terminal
check: checks
devel: dev
develop: dev
dist: dists
install: install-system
pypi: pypi-publish
styles: style
test: test-unit
unittest: test-unit
wheel: wheels
