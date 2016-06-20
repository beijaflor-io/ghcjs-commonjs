all:
	make hello-world-example
	make hello-variable-name
	make fibonacci
	make failure

hello-world-example:
	cd ./examples/hello-world && stack build
	cd ./examples/hello-world && npm install
	cd ./examples/hello-world && node ./index.js

hello-variable-name:
	cd ./examples/hello-variable-name && stack build
	cd ./examples/hello-variable-name && npm install
	cd ./examples/hello-variable-name && node ./index.js

fibonacci:
	cd ./examples/fibonacci && stack build
	cd ./examples/fibonacci && npm install
	cd ./examples/fibonacci && node ./index.js

failure:
	cd ./examples/failure && stack build
	cd ./examples/failure && npm install
	cd ./examples/failure && node ./index.js
