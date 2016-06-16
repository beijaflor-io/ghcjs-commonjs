haskell-from-node:
	node HaskellFromNode.js

node-from-haskell:
	stack ghc --compiler ghcjs-0.2.0.20160414_ghc-7.10.3 -- -o NodeFromHaskell.jsexe NodeFromHaskell.hs 
	node ./NodeFromHaskell.jsexe/all.js

clean:
	rm -rf *.jsexe
	rm -f *.hi
	rm -f *.ho
	rm -f *.js_hi
	rm -f *.js_o
