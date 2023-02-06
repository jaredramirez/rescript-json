.PHONY: dev build dev-doces docs clean dev-test test start

dev:
	rescript build -with-deps -w
	
build:
	rescript build -with-deps

clean:
	rescript clean
	
test:
	make build && node ./lib/js/tests/JsonTests.js
	
dev-test:
	chokidar "src/**/*.res" "src/**/*.resi" "tests/**/*.res" -c "make test" --initial

start:
	nodemon ./lib/js/tests/JsonTests.js
