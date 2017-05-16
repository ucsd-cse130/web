all:
	ocamllex arithLexer.mll
	ocamlyacc arithParser.mly
	ocamlc -c arithInterpreter.ml
	ocamlc -c arithParser.mli
	ocamlc -c arithLexer.ml
	ocamlc -c arithParser.ml
	ocamlc -c arith.ml
	ocamlmktop arithLexer.cmo arithParser.cmo arithInterpreter.cmo arith.cmo -o arith.top


clean:
	rm -f *.cm[io] arithLexer.ml arithParser.ml arithParser.mli
