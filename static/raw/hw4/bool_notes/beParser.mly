%{
open BeAst
%}

%token <string> Id
%token TRUE FALSE
%token OR AND XOR NEG
%token LPAREN RPAREN
%token EOF

%start expr
%type <BeAst.bexpr> expr

%%

expr: expr OR xexpr  { Or($1,$3) }
    | xexpr          { $1 }

xexpr: xexpr XOR nexpr { Xor($1,$3) }
    | nexpr          { $1 }

nexpr: nexpr AND atom { And($1,$3) }
    | atom           { $1 }

atom: TRUE          { Const(true) }
    | FALSE         { Const(false) }
    | Id            { Var($1) }
    | LPAREN expr RPAREN { $2 }
    | NEG atom      { Neg($2) }