.PHONY: dev build docs clean test start

dev:
	rescript build -with-deps -w
	
build:
	rescript build -with-deps

docs:
	make build && rm -rf ./lib/bs/tests && bsdoc build RescriptJson

clean:
	rescript clean
	
test:
	node ./lib/js/tests/JsonTests.js
	
start:
	nodemon ./lib/js/tests/JsonTests.js
