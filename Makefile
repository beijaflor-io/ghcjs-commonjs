all: FORCE
	make README
	make hello-world-example
	make hello-variable-name
	make fibonacci
	make failure

	make run-README
	make run-hello-world-example
	make run-hello-variable-name
	make run-fibonacci
	make run-failure

test: FORCE
	cd ./test && stack test

README: FORCE
	cd ./README && stack build --install-ghc
	cd ./README && npm install ../ghcjs-require
	cd ./README && npm install

run-README: FORCE
	@echo "README ---------------------------------------------------------------"
	cd ./README && node ./js/index.js

hello-world-example: FORCE
	cd ./examples/hello-world && stack build --install-ghc
	cd ./examples/hello-world && npm install ../../ghcjs-require
	cd ./examples/hello-world && npm install

run-hello-world-example: FORCE
	@echo "hello-world ----------------------------------------------------------"
	cd ./examples/hello-world && node ./index.js

hello-variable-name: FORCE
	cd ./examples/hello-variable-name && stack build --install-ghc
	cd ./examples/hello-variable-name && npm install ../../ghcjs-require
	cd ./examples/hello-variable-name && npm install

run-hello-variable-name: FORCE
	@echo "hello-variable-name --------------------------------------------------"
	cd ./examples/hello-variable-name && node ./index.js

fibonacci: FORCE
	cd ./examples/fibonacci && stack build --install-ghc
	cd ./examples/fibonacci && npm install ../../ghcjs-require
	cd ./examples/fibonacci && npm install

run-fibonacci: FORCE
	@echo "fibonacci ------------------------------------------------------------"
	cd ./examples/fibonacci && node ./index.js

failure: FORCE
	cd ./examples/failure && stack build --install-ghc
	cd ./examples/failure && npm install ../../ghcjs-require
	cd ./examples/failure && npm install

run-failure: FORCE
	@echo "failure --------------------------------------------------------------"
	cd ./examples/failure && node ./index.js

webpack: FORCE
	cd ./examples/webpack && stack build --install-ghc
	cd ./examples/webpack && npm install ../../ghcjs-require
	cd ./examples/webpack && npm install ../../ghcjs-loader
	cd ./examples/webpack && npm install

pandoc: FORCE
	cd ./examples/pandoc && stack build --install-ghc
	cd ./examples/pandoc && npm install ../../ghcjs-require
	cd ./examples/pandoc && npm install ../../ghcjs-loader
	cd ./examples/pandoc && npm install

run-pandoc: FORCE
	@echo "pandoc ---------------------------------------------------------------"
	cd ./examples/pandoc && node ./node-main.js

FORCE:
