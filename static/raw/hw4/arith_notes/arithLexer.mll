{
open ArithParser
}

rule token = parse
  | eof                                 { EOF }
  | [' ' '\t' '\r' '\n']                { token lexbuf }
  | ['0'-'9']+ as n                     { CONST (int_of_string n) }
  | ['a'-'z']['A'-'z' '0'-'9']* as x    { VAR x }
  | '+'                                 { PLUS }
  | '-'                                 { MINUS }
  | '*'                                 { TIMES }
  | '/'                                 { DIVIDE }
  | '('                                 { LPAREN }
  | ')'                                 { RPAREN }
  | _                                   { DUNNO  }
