dev:
	rescript build -with-deps -w
	
build:
	rescript build -with-deps

clean:
	rescript clean
	
test:
	node ./lib/js/tests/json.test.js
	
start:
	nodemon ./lib/js/tests/json.test.js
