.PHONY:

build-node: .PHONY
	stack ghc --compiler ghcjs-0.2.0.20160414_ghc-7.10.3 -- -o Main.jsexe Main.hs
	node --require ../ghcjs-loader/ghcjs-register.js ./src/index.js 

build-webpack: .PHONY
	webpack
