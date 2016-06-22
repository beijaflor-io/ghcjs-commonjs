all: FORCE
	make README
	make hello-world-example
	make hello-variable-name
	make fibonacci
	make failure
	make pandoc

README: FORCE
	cd ./README && stack build
	cd ./README && npm install
	cd ./README && node ./js/index.js

hello-world-example: FORCE
	cd ./examples/hello-world && stack build
	cd ./examples/hello-world && npm install
	cd ./examples/hello-world && node ./index.js

hello-variable-name: FORCE
	cd ./examples/hello-variable-name && stack build
	cd ./examples/hello-variable-name && npm install
	cd ./examples/hello-variable-name && node ./index.js

fibonacci: FORCE
	cd ./examples/fibonacci && stack build
	cd ./examples/fibonacci && npm install
	cd ./examples/fibonacci && node ./index.js

failure: FORCE
	cd ./examples/failure && stack build
	cd ./examples/failure && npm install
	cd ./examples/failure && node ./index.js

pandoc: FORCE
	cd ./examples/pandoc && stack build
	cd ./examples/pandoc && npm install
	cd ./examples/pandoc && node ./node-main.js

FORCE:
