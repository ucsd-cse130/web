let parse_string str =
  let lb = Lexing.from_string str in
    ArithParser.aexpr ArithLexer.token lb

let token_list_of_string s =
  let lb = Lexing.from_string s in
  let rec helper l = 
    try 
      let t = ArithLexer.token lb in
      if t = ArithParser.EOF then List.rev l else helper (t::l)
    with _ -> List.rev l
  in helper []

let eval_string env str = ArithInterpreter.eval env (parse_string str) 

