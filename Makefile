dev:
	rescript build -with-deps -w
	
build:
	rescript build -with-deps

clean:
	rescript clean
	
test:
	node ./lib/js/tests/JsonTests.js
	
start:
	nodemon ./lib/js/tests/JsonTests.js
