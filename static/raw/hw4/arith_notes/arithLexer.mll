{
open ArithParser
}

rule token = parse
  | eof                                 { EOF }
  | [' ' '\t' '\r' '\n']                { token lexbuf } 
  | ['0'-'9']+ as l                     { CONST (int_of_string l) }
  | ['a'-'z']['A'-'z' '0'-'9']* as l    { VAR l }
  | '+'                                 { PLUS }
  | '-'                                 { MINUS }
  | '*'                                 { TIMES }
  | '/'                                 { DIVIDE }
  | '('                                 { LPAREN }
  | ')'                                 { RPAREN }
