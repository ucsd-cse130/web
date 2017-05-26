
open ArithInterpreter

let parseAexpr (str : string) : aexpr =
  let lb = Lexing.from_string str in
    ArithParser.burrito ArithLexer.token lb

let token_list_of_string s =
  let lb = Lexing.from_string s in
  let rec helper l =
    try
      let t = ArithLexer.token lb in
      if t = ArithParser.EOF then List.rev l else helper (t::l)
    with _ -> List.rev l
  in helper []

let evalString env str = ArithInterpreter.eval env (parseAexpr str)
