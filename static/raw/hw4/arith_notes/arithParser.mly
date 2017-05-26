%{
open ArithInterpreter
%}

%token <int> CONST
%token <string> VAR
%token TIMES DIVIDE PLUS MINUS
%token LPAREN RPAREN
%token DUNNO
%token EOF

%left  PLUS MINUS
%left  TIMES DIVIDE


%start burrito
%type <ArithInterpreter.aexpr> burrito
%%

burrito:
  | binExpr                       { $1              }
  | CONST                         { Const $1        }
  | VAR                           { Var $1          }
  | LPAREN burrito RPAREN         { $2              }

binExpr:
  | burrito TIMES  burrito        { Times ($1, $3)  }
  | burrito DIVIDE burrito        { Divide ($1, $3) }
  | burrito PLUS   burrito        { Plus ($1, $3)   }
  | burrito MINUS  burrito        { Minus ($1, $3)  }
