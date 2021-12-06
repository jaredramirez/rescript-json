.PHONY: dev build dev-doces docs clean dev-test test start

dev:
	rescript build -with-deps -w
	
build:
	rescript build -with-deps

dev-docs:
	chokidar "src/**/*.res" "src/**/*.resi" "tests/**/*.res" -c "make docs" --initial

docs:
	make build && rm -rf ./lib/bs/tests && bsdoc build RescriptJson

clean:
	rescript clean
	
test:
	make build && node ./lib/js/tests/JsonTests.js
	
dev-test:
	chokidar "src/**/*.res" "src/**/*.resi" "tests/**/*.res" -c "make test" --initial

start:
	nodemon ./lib/js/tests/JsonTests.js
