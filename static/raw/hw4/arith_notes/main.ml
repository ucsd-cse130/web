let parse_string str =
  let lb = Lexing.from_string str in
    ArithParser.expr ArithLexer.token lb

let token_list_of_string str =
  let lb = Lexing.from_string str in
  let rec loop () =
    let tok = ArithLexer.token lb in
      tok :: loop ()
  in loop ()
