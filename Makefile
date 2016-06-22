all: FORCE
	make README
	make hello-world-example
	make hello-variable-name
	make fibonacci
	make failure
	make pandoc

	make run-README
	make run-hello-world-example
	make run-hello-variable-name
	make run-fibonacci
	make run-failure
	make run-pandoc

README: FORCE
	cd ./README && stack build
	cd ./README && npm install

run-README: FORCE
	@echo "README ---------------------------------------------------------------"
	cd ./README && node ./js/index.js

hello-world-example: FORCE
	cd ./examples/hello-world && stack build
	cd ./examples/hello-world && npm install

run-hello-world-example: FORCE
	@echo "hello-world ----------------------------------------------------------"
	cd ./examples/hello-world && node ./index.js

hello-variable-name: FORCE
	cd ./examples/hello-variable-name && stack build
	cd ./examples/hello-variable-name && npm install

run-hello-variable-name: FORCE
	@echo "hello-variable-name --------------------------------------------------"
	cd ./examples/hello-variable-name && node ./index.js

fibonacci: FORCE
	cd ./examples/fibonacci && stack build
	cd ./examples/fibonacci && npm install

run-fibonacci: FORCE
	@echo "fibonacci ------------------------------------------------------------"
	cd ./examples/fibonacci && node ./index.js

failure: FORCE
	cd ./examples/failure && stack build
	cd ./examples/failure && npm install

run-failure: FORCE
	@echo "failure --------------------------------------------------------------"
	cd ./examples/failure && node ./index.js

pandoc: FORCE
	cd ./examples/pandoc && stack build
	cd ./examples/pandoc && npm install

run-pandoc: FORCE
	@echo "pandoc ---------------------------------------------------------------"
	cd ./examples/pandoc && node ./node-main.js

FORCE:
