%{
open ArithInterpreter
%}

%token <int> CONST
%token <string> VAR
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN
%token EOF

%start aexpr
%type <ArithInterpreter.aexpr> aexpr
%%

aexpr:
  | aexpr PLUS  aexpr2         { Plus ($1, $3) }
  | aexpr MINUS aexpr2         { Minus ($1, $3) }
  | aexpr2                      { $1 }

aexpr2:
  | aexpr2 TIMES  aexpr3        { Times ($1, $3) }
  | aexpr2 DIVIDE aexpr3        { Divide ($1, $3) }
  | aexpr3                      { $1 }

aexpr3:
  | CONST                       { Const $1 }
  | VAR                         { Var $1 }
  | LPAREN aexpr RPAREN        { $2 }
