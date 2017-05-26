%{
open ArithInterpreter
%}

%token <int> CONST
%token <string> VAR
%token TIMES DIVIDE PLUSSS MINUSSS
%token LPAREN RPAREN
%token DUNNO
%token EOF

%left PLUSSS MINUSSS
%left TIMES DIVIDE
  
%start burrito
%type <ArithInterpreter.aexpr> burrito
%%

burrito:
  | burrito TIMES  burrito        { Times ($1, $3)  }
  | burrito DIVIDE burrito        { Divide ($1, $3) }
  | burrito PLUSSS   burrito      { Plus ($1, $3)   }
  | burrito MINUSSS  burrito      { Minus ($1, $3)  }
  | CONST                         { Const $1        }
  | VAR                           { Var $1          }
  | LPAREN burrito RPAREN         { $2              }
