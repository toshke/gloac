.EXPORT_ALL_VARIABLES:

RUN_RUBY_CMD=docker-compose run --rm -v $$PWD:/src -w /src ruby
CFHL_DOCKER_TAG ?= latest

all: clean build test

clean:
	rm -f *.gem
	docker-compose down
.PHONY: clean

build:
	$(RUN_RUBY_CMD) make _build
.PHONY: clean

rubyShell:
	$(RUN_RUBY_CMD) bash
.PHONY: rubyShell

test:
	$(RUN_RUBY_CMD) make _test
.PHONY: test

_build:
	gem build gloac.gemspec

_local_install:
	gem install gloac-*.gem

_test:
	gem install bundler:2.0.1
	bundle install
	bundle exec rspec