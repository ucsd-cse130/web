#!/bin/sh
ocamllex beLexer.mll && \
ocamlyacc beParser.mly && \
ocamlc -c beAst.ml && \
ocamlc -c beParser.mli && \
ocamlc -c beParser.ml && \
ocamlc -c beLexer.ml && \
ocamlc -c beMain.ml && \
ocamlmktop -o be.top beAst.cmo beParser.cmo beLexer.cmo beMain.cmo