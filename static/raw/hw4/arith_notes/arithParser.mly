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
  | aexpr PLUS   aexpr        { Plus ($1, $3)   }
  | aexpr MINUS  aexpr        { Minus ($1, $3)  }
  | aexpr TIMES  aexpr        { Times ($1, $3)  }
  | aexpr DIVIDE aexpr        { Divide ($1, $3) }
  | CONST                     { Const $1              }
  | VAR                       { Var $1          }
  | LPAREN aexpr RPAREN       { $2              }
