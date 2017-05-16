{
open BeParser
}

rule token = parse
  | [' ' '\t' '\n']    { token lexbuf } (* skip spaces *)
  | "true"             { TRUE }
  | "false"            { FALSE }
  | "||"               { OR }
  | "&&"               { AND }
  | "^"                { XOR }
  | "-"                { NEG }
  | "("                { LPAREN }
  | ")"                { RPAREN }
  | ['A'-'Z' 'a'-'z' '_']['A'-'Z' 'a'-'z' '0'-'9' '_']* as str
                       { Id(str) }
  | _ as chr           { failwith ("lex error: "^(Char.escaped chr))}
  | eof                { EOF }