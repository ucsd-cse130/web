---
title: HW 4, due 5/29/2017 (230 pts)
headerImg: angles.jpg
---

## Hints

See the following for hints on different parts of this assignment

1. [bool-parser](https://github.com/ucsd-cse130/web/tree/master/static/raw/hw4/bool_notes)
2. [arith-parser-interpreter](https://github.com/ucsd-cse130/web/tree/master/static/raw/hw4/arith_notes)
3. [arith-parser-interpreter](https://github.com/ucsd-cse130/web/tree/master/static/raw/hw4/arith_notes/interp.ml)

## Overview

The overall objective of this assignment is to
fully understand the notion of scoping, binding,
environments and closures, by implementing an
interpreter for a subset of ML.

In addition, in this assignment you will be building
a lexer and a parser.

No individual function requires more than 15-25
lines, so if you're answer is longer, you can be sure
that you need to rethink your solution.

The template for the assignment, as well as several
test cases is available as a single zip file
[hw4.zip](/static/raw/hw4.zip) that you
need to **download** and **unzip**.

The files contain several skeleton ML functions,
with missing bodies, i.e. expressions, which currently
contain the text `failwith "to be written"`.
Your task is to replace the text in those files with the
the appropriate ML code for each of those expressions.

**Note:** All the solutions can be done using the purely
functional fragment of OCaml, using constructs covered
in class, and most require the use of **recursion**.
Solutions using imperative features such as references,
will receive **no credit**. Feel free to use any library
functions that you want. It is a good idea to start this
assignment *very early* as it is longer than the first
three assignments (and will clarify your understanding
of ML in time for the midterm!)

## Assignment Testing and Evaluation

Your functions/programs **must** compile and/or run
on a **ACS Linux** machine (e.g. `ieng6.ucsd.edu`)
as this is where your solutions will be checked.
While you may develop your code on any system, ensure
that your code runs as expected on an ACS machine prior
to submission. You should test your code in the directories
from which the zip files (see below) will be created, as
this will approximate the environment used for grading the
assignment.

Most of the points, will be awarded automatically, by
**evaluating your functions against a given test suite**.
`test.ml` contains a very small suite of tests which
gives you a flavor of of these tests. At any stage, by
typing at the UNIX shell :

~~~~~{.bash}
> ./nanoml.top test.ml > log
~~~~~

you will get a report on how your code stacks up against
the simple tests.

**If the code you submit does not compile with `make`,
there will be no `nanoml.top`, and you will get 0 for the
assignment.**

**The last line of the file `log` must contain the word
``Compiled" otherwise you get a zero for the whole assignment**.

If for some problem, you cannot get the code to compile,
leave it as is with the `failwith ...` with your partial
solution enclosed below as a comment.

The second last line of the log file will contain your
overall score, and the other lines will give you a readout
for each test. You are encouraged to try to understand
the code in `test.ml`, and subsequently devise your own
tests and add them to `test.ml`, but you will not be
graded on this.

## Submission Instructions

Go into the UNIX shell and type:

~~~~~{.ocaml}
> make turnin
~~~~~

This will run `turnin` which will provide you with a
confirmation of the submission process.

## Data Structures and Overview

In this assignment, you will build an interpreter for a
subset of ML. The following data types (in `nano.ml`)
are used to represent the different elements of the
language.

### Binary Operators

NanoML uses the following **binary** operators encoded
within the interpreter as Ocaml values of type `binop`.

~~~~~{.ocaml}
type binop =
  Plus
| Minus
| Mul
| Div
| Eq
| Ne
| Lt
| Le
| And
| Or          
| Cons

~~~~~

### Expressions

As with ML, all Nano-ML programs correspond to **expressions**
each of which will be represented within your interpreter
by Ocaml values of type `expr`.


~~~~~{.ocaml}
type expr =   
    Const of int             
  | True                      
  | False                       
  | NilExpr                     
  | Var of string               
  | Bin of expr * binop * expr    
  | If  of expr * expr * expr     
  | Let of string * expr * expr     
  | App of expr * expr              
  | Fun of string * expr             
  | Letrec of string * expr * expr
~~~~~

The following lists some NanoML expressions,
and the Ocaml value (of type `expr`) used to represent
the expression inside your interpreter.

1. Let-bindings

~~~~~{.ocaml}
let x = 3 in x + x		
~~~~~

is represented by

~~~~~{.ocaml}
Let ("x", Const 3, Bin (Var "x", Plus, Var "x"))
~~~~~

2. Function definitions

~~~~~{.ocaml}
fun x -> x + 1
~~~~~

is represented by

~~~~~{.ocaml}
Fun ("x", Bin (Var "x", Plus, Const 1))
~~~~~

3. Function applications ("calls")

~~~~~{.ocaml}
f x									
~~~~~

is represented by

~~~~~{.ocaml}
App (Var "f", Var "x")
~~~~~

4. Recursive functions

~~~~~{.ocaml}
let rec f = fun x -> f x in f 5	    
~~~~~

is represented by

~~~~~{.ocaml}
Letrec ("f", Fun ("x", App (Var "f", Var "x"), App (Var "f", Const 5)))
~~~~~


### Values

Finally, we will represent NanoML **values* using the
following Ocaml datatype

~~~~~{.ocaml}
type value =  
  Int of int                 
| Bool of bool                
| Closure of env * string option * string * expr
| Nil                           
| Pair of value * value          

and env = (string * value) list
~~~~~

Intuitively, the NanoML integer value `4` and boolean value
`true` are represented by the Ocaml values `Int 4` and
`Bool true`. The more interesting case is for closures
that correspond to function values ([Lecture 7](/static/lec7-closure-2x2.pdf)

- `Closure (env, Some "f", "x", e)` represents a function *named* `"f"`
  (for recursive functions) with argument `"x"` and body-expression `e`
  that was defined in an environment `env`.

- `Closure (env, None, "x", e)` represents an *anonymous* (hence,
  non-recursive)  function with argument `"x"` and body-expression
  `e` that was defined in an environment `env`.

The environment itself is a value of type `env` which is a *phone-book*
represented as a list of `string * value` pairs that maps each bound name
to its value.


## Problem 1: NanoML Interpreter (nano.ml)

**NOTE:** For this problem, you will use `ocaml-top` to edit and test the file `nano.ml`.

In this problem, you will implement an interpreter for NanoML.

### (a) 25 points

First consider the (restricted subsets of) types described below:

~~~~~{.ocaml}
type binop = Plus | Minus | Mul | Div

type expr  = Const of int 		
           | Var of string                
           | Bin of expr * binop * expr    

type value = Int of int		

type env   = (string * value) list
~~~~~

Here, `binop`, and `expr` are used to represent simple NanoML
expressions.

- An *expression* is either an integer constant,
  a variable, or a binary operator applied to two sub-expressions.

- A *value* is an integer, and an *environment* is a list of pairs
  of variable names and values.

Use `listAssoc` to write an Ocaml function

~~~~~{.ocaml}
val lookup: 'a * ('a * 'b) list -> 'b
~~~~~

that finds the most recent binding for a variable
(i.e. the first from the left) in the list representing
the environment. If no such value is found, you should
raise an exception:

~~~~~{.ocaml}
raise (MLFailure "not found")
~~~~~

Next, use `lookup` to  write an Ocaml function

~~~~~{.ocaml}
val eval : env * expr -> value
~~~~~

that when called with the pair `(evn, e)` evaluates the
NanoML expression `e` in the environment `evn` (i.e. uses
`evn` for the values of the **free variables** in `e`) and
raises an exception `MLFailure ("variable not bound: x")`
if the expression contains a free variable `"x"` that is
not bound in `evn`.

Once you have implemented this functionality and
recompiled, you should get the following behavior:

~~~~~{.ocaml}
# let evn = [("z1",Int 0);("x",Int 1);("y",Int 2);("z",Int 3);("z1",Int 4)];;
val evn : (string * Nano.value) list =
  [("z1", Int 0); ("x", Int 1); ("y", Int 2); ("z", Int 3); ("z1", Int 4)]

# let e1 = Bin(Bin(Var "x",Plus,Var "y"), Minus, Bin(Var "z",Plus,Var "z1"));;
val e1 : Nano.expr =
  Bin (Bin (Var "x", Plus, Var "y"), Minus, Bin (Var "z", Plus, Var "z1"))

# eval (evn, e1);;
- : Nano.value = Int 0

# eval (evn, Var "p");;
Exception: Nano.MLFailure "variable not bound: p".
~~~~~

### (b) 20 points

Next, add support for the binary operators

~~~~~{.ocaml}
type binop = Plus | Minus | Mul | Div
           | Eq | Ne | Lt | Le | And | Or
~~~~~

This will require using the new value type `Bool`

~~~~~{.ocaml}
type value = Int of int		
           | Bool of bool
~~~~~

The operators `Eq` and `Ne` should work if both operands
are `Int` values, or if both operands are `Bool` values.  

The operators `Lt` and `Le` are only defined for `Int`
values, and `&&` and `||` are only defined for `Bool`
values. For all other (invalid) arguments, a `MLFailure`
exception should be raised with an appropriate error message.

Next, implement the evaluation of `If` expressions.  

To evaluate `If(p,t,f)` your evaluator should first evaluate `p`
and if it evaluates to the true value (as a `Bool`) then the
expression `t` should be evaluated and its value returned as the
value of the entire `If` expression. Instead, if `p` evaluates
to the false value, then `f` should be evaluated and that result
should be returned.  If `p` does not evaluate to a `Bool` value,
then your evaluator should raise an  `MLFailure` exception carrying
an appropriate error message.

Once you have implemented this functionality,
you should get the following behavior:

~~~~~{.ocaml}
# let evn =[("z1",Int 0);("x",Int 1);("y",Int 2);("z",Int 3);("z1",Int 4)];;
val evn : (string * Nano.value) list =
  [("z1", Int 0); ("x", Int 1); ("y", Int 2); ("z", Int 3); ("z1", Int 4)]

# let e1 =If(Bin(Var "z1",Lt,Var "x"),Bin(Var "y",Ne,Var "z"),False);;
val e1 : Nano.expr =
  If (Bin (Var "z1", Lt, Var "x"), Bin (Var "y", Ne, Var "z"), False)

# eval (evn,e1);;
- : Nano.value = Bool true

# let e2 =If(Bin(Var "z1",Eq,Var "x"),Bin(Var "y",Le,Var "z"),Bin(Var "z",Le,Var "y"));;
val e2 : Nano.expr =
  If (Bin (Var "z1", Eq, Var "x"), Bin (Var "y", Le, Var "z"),
   Bin (Var "z", Le, Var "y"))

# eval (evn,e2);;
- : Nano.value = Bool false
~~~~~


### (c) 25 points

Now consider the extended the types as shown below which includes
the *let-in* expressions which introduce local bindings exactly
as in OCaml.

~~~~~{.ocaml}
type expr = ...
  | Let of string * expr * expr   
  | Letrec of string * expr * expr   
~~~~~

The expression `Let (x, <e1> , <e2>)` should be evaluated
as the ML expression `let x = <e1> in <e2>`. Similarly,
`Letrec (x, <e1>, <e2>)` should be evaluated as
`let rec x = <e1> in <e2>`.  (Since at this point,
we do not support functions, `Let` and `Letrec`
should do the same thing.

Once you have implemented this functionality and
recompiled, you should get the following behavior:

~~~~~{.ocaml}
# let e1 = Bin(Var "x",Plus,Var "y");;
val e1 : Nano.expr = Bin (Var "x", Plus, Var "y")

# let e2 = Let("x",Const 1,Let("y",Const 2,e1));;
val e2 : Nano.expr =
  Let ("x", Const 1, Let ("y", Const 2, Bin (Var "x", Plus, Var "y")))

# eval ([],e2);;
- : Nano.value = Int 3

# let e3 = Let("x",Const 1,Let("y",Const 2,Let("z",e1,Let("x",Bin(Var "x",Plus,Var "z"),e1))));;
val e3 : Nano.expr =
	  Let ("x", Const 1,
	   Let ("y", Const 2,
	    Let ("z", Bin (Var "x", Plus, Var "y"),
	     Let ("x", Bin (Var "x", Plus, Var "z"), Bin (Var "x", Plus, Var "y")))))

# eval ([],e3);;
- : Nano.value = Int 6
~~~~~

### (d)  25 points

Next, extend the evaluator so it includes the expressions corresponding
to function definitions and applications.

~~~~~{.ocaml}
type expr = ...
		| App of expr * expr
		| Fun of string * expr
~~~~~

Naturally, to handle functions, you will need to extend the set of
values yielded by your evaluator to include closures.

~~~~~{.ocaml}
type value = ...
		   | Closure of env * string option * string * expr
~~~~~

Recall that `App(<e1>, <e2>)` corresponds to the ML
expression `<e1> <e2>` (i.e. applying the argument
`<e2>` to the function `<e1>`), and `Fun ("x", <e>)`
corresponds to the ML function defined `fun x -> <e>`.

For now, assume the functions *are not recursive*.
However, functions do have values represented by
the `Closure (evn, n, x, e)` where `evn` is the
environment at the point where that function was
declared, and `n`, `x` , and `e` are name, formal
and body expression of the function.  

- If the function is anonymous or declared in a
  `let`-binding the name component of the closure
  tuple should be `None`.

- If the function is declared in a `let rec` binding
  statement, then the name of the function should be
  `Some f` (where `f` is the name of the function, i.e. the
  variable bound in the `let rec` function).

Extend your implementation of `eval` by adding the
appropriate cases for the new type constructors.
Once you have implemented this functionality and
recompiled, you should get the following behavior:


~~~~~{.ocaml}
# eval ([],Fun ("x",Bin(Var "x",Plus,Var "x")));;
- : Nano.value = Closure ([], None, "x", Bin (Var "x", Plus, Var "x"))

# eval ([],App(Fun ("x",Bin(Var "x",Plus,Var "x")),Const 3));;
- : Nano.value = Int 6

# let e3=Let("h",Fun("y",Bin(Var "x", Plus, Var "y")),App(Var "f",Var "h"));;
val e3 : Nano.expr =
  Let ("h", Fun ("y", Bin (Var "x", Plus, Var "y")), App (Var "f", Var "h"))

# let e2 = Let("x",Const 100,e3);;
val e2 : Nano.expr =
  Let ("x", Const 100,
   Let ("h", Fun ("y", Bin (Var "x", Plus, Var "y")), App (Var "f", Var "h")))

# let e1 = Let("f",Fun("g",Let("x",Const 0,App(Var "g",Const 2))),e2);;
val e1 : Nano.expr =
  Let ("f", Fun ("g", Let ("x", Const 0, App (Var "g", Const 2))),
   Let ("x", Const 100,
    Let ("h", Fun ("y", Bin (Var "x", Plus, Var "y")),
     App (Var "f", Var "h"))))

# eval ([],e1);;
- : Nano.value = Int 102

# eval ([],Letrec("f",Fun("x",Const 0),Var "f"));;
- : Nano.value = Closure ([], Some "f", "x", Const 0)
~~~~~

### (e) 30 points
Make the above work for recursively defined functions
(declared with `let rec`). Once you have implemented
this functionality and recompiled, you should get the
following behavior:

~~~~~{.ocaml}
# eval ([],Letrec("fac",Fun("n",If(Bin(Var "n",Eq,Const 0),Const 1,Bin(Var "n",Mul,App(Var "fac",Bin(Var "n",Minus,Const 1))))),App(Var "fac",Const 10)));;
- : Nano.value = Int 3628800
~~~~~


### (f) 40 points (extra credit)

Extend your program to support operations on lists.

~~~~~{.ocaml}
type binop = ...
           | Cons

type expr = ...
          | NilExpr

type value = ...
           | Nil
           | Pair of value * value
~~~~~

In addition to the changes to the data types, add support
for two functions `"hd"` and `"tl"` which do what the
corresponding ML functions do. Once you have implemented
this functionality and recompiled, you should get the
following behavior:

~~~~~{.ocaml}
# eval ([],Bin(Const 1,Cons,Bin(Const 2,Cons,NilExpr)));;
- : Nano.value = Pair (Int 1, Pair (Int 2, Nil))

# eval ([],App(Var "hd",Bin(Const 1,Cons,Bin(Const 2,Cons,NilExpr))));;
- : Nano.value = Int 1

# eval ([],App(Var "tl",Bin(Const 1,Cons,Bin(Const 2,Cons,NilExpr))));;
- : Nano.value = Pair (Int 2, Nil)
~~~~~


## Problem 2: NanoML Lexer (nanoLex.mll) and Parser (nanoParse.mly)

**NOTE:** From now on, you are done with `ocaml-top`.
    For this problem **your favorite editor** to modify
    `nanoLex.mll` and `nanoParse.mly`, recompile at the
    UNIX shell using `make` and test by running `nanoml.top`.

The goal of this problem is to write a **lexer** and **parser**
for NanoML using (Ocaml)Lex and (Ocaml)Yacc. Google those terms
for more information about them!
In each subproblem, we will increase the complexity of the
expressions parsed by your implementation.

### (a) 15 points
We will begin by making our parser recognize some of
the simplest NanoML expressions: constants and variables.

Begin with `nanoParse.mly` and define tokens `TRUE`, `FALSE`,
and `Id`. Note that a token `Num` is already defined.  An `Id`
token should have a single string argument, which holds the
name of the variable (identifier) represented by the token.

Next, add rules to `nanoLex.mll`.  A `Num` constant is a
sequence of one or more digits.  An `Id` is a letter (capital
or lowercase) followed by zero or more letters or digits.
The strings `"true"` and `"false"` should return the
corresponding tokens `TRUE` and `FALSE`.

Finally, add a rule to `nanoLex.mll` to ignore whitespace which
includes space, newline `\n`, carriage return `\r`, and tab `\t`.

Once you have implemented this functionality, you should get the
following behavior. **Note:** `$` is the unix-shell prompt, `#` is
a `nanoml.top` prompt.

~~~~~{.ocaml}
$ make
...
~~~~~

You should now hopefully have in your directory a file called
`nanoml.top`, which is an Ocaml shell that is pre-loaded with
the modules corresponding to your NanoML implementation.

~~~~~{.ocaml}
$ ./nanoml.top
NanoML

$ ./nanoml.top
        Objective Caml version ...

# NanoLex.token (Lexing.from_string "true");;
- : NanoParse.token = NanoParse.TRUE

# Main.token_list_of_string "true false 12345 foo bar baz";;
- : NanoParse.token list = [NanoParse.TRUE; NanoParse.FALSE; NanoParse.Num 12345; NanoParse.Id "foo"; NanoParse.Id "bar"; NanoParse.Id "baz"]
~~~~~

Now return to `nanoParse.mly`.  Add rules to the parser so that
`true`, `false`, integers, and identifiers are parsed into
expressions of type `Nano.expr` as described above and shown
in  `nano.ml`.

Once you have implemented this functionality, you should get
the following behavior (recall `$` is the unix shell and `#`
the Ocaml prompt.)

~~~~~{.ocaml}
$ make

(* hopefully this succeeds without errors. *)

$ ./nanoml.top
NanoML

$ ./nanoml.top
        Objective Caml version ...

# NanoParse.exp NanoLex.token (Lexing.from_string "true");;
- : Nano.expr = Nano.True

# NanoParse.exp NanoLex.token (Lexing.from_string "false");;
- : Nano.expr = Nano.False

# NanoParse.exp NanoLex.token (Lexing.from_string "   \n123");;
- : Nano.expr = Nano.Const 123

# NanoParse.exp NanoLex.token (Lexing.from_string "\rfoo");;
- : Nano.expr = Nano.Var "foo"
~~~~~

### (b) 15 points

Add the following tokens to the lexer and parser.


String       Token
--------     --------
`let`        `LET`
`rec`        `REC`
`=`          `EQ`
`in`         `IN`
`fun`        `FUN`
`->`         `ARROW`
`if`         `IF`
`then`       `THEN`
`else`       `ELSE`


These should be parsed as in real ML to `Nano.Let`, `Nano.Letrec`,
`Nano.Fun`, and `Nano.If` expressions (of type `Nano.expr`).  
That is,

- a **let** expression should have the form `let <id> = <expr> in <expr>`,
- a **letrec** expression should have the form `let rec <id> = <expr> in <expr>`
- a **function** expression should have the form `fun <id> -> <expr>` and
- an **if** expression should be `if <expr> then <expr> else <expr>".

Here <id> denotes any identifier from part (a),
and <expr> denotes any expression from part (a),
or any let / letrec / fun / if expression.

Once you have implemented this functionality
and recompiled (by typing `make` at the unix prompt)
you should get the following behavior at the `./nanoml.top`
prompt:

~~~~~{.ocaml}
# Main.token_list_of_string "let rec foo = fun x -> if y then z else w in foo";;
- : NanoParse.token list =
	[NanoParse.LET; NanoParse.REC; NanoParse.Id "foo"; NanoParse.EQ;
	 NanoParse.FUN; NanoParse.Id "x"; NanoParse.ARROW; NanoParse.IF;
	 NanoParse.Id "y"; NanoParse.THEN; NanoParse.Id "z"; NanoParse.ELSE;
	 NanoParse.Id "w"; NanoParse.IN; NanoParse.Id "foo"]

# Main.string_to_expr "let rec foo = fun x -> if y then z else w in foo";;
- : Nano.expr =	Nano.Letrec ("foo", Nano.Fun ("x", Nano.If (Nano.Var "y", Nano.Var "z", Nano.Var "w")), Nano.Var "foo")
~~~~~

### (c) 15 points

Add the following tokens to the lexer and parser.

| **String** | **Token** |
|:-----------|:----------|
|  `+`       |  `PLUS`   |
|  `-`       |  `MINUS`  |
|  `*`       |  `MUL`    |
|  `/`       |  `DIV`    |
|  `<`       |  `LT`     |   
|  `<=`      |  `LE`     |
|  `!=`      |  `NE`     |
|  `&&`      |  `AND`    |
|  `||`      |  `OR`     |

Add all of these as binary operators to your parser.  
Each should result in a `Nano.Bin` expression with
the corresponding `Nano.binop`.  The arguments to
these binary operators may be *any* expressions.  
(You don't need to worry about types.  `"3+true||7"`
is allowed as far as the parser is concerned.)

Once you have implemented this functionality and
recompiled, you should get the following behavior
at the `./nanoml.top` prompt:


~~~~~{.ocaml}
# Main.token_list_of_string "+ - /*|| < <= = && !=";;
- : NanoParse.token list =
[NanoParse.PLUS; NanoParse.MINUS; NanoParse.DIV;
 NanoParse.MUL; NanoParse.OR; NanoParse.LT;
 NanoParse.LE; NanoParse.EQ; NanoParse.AND; NanoParse.NE]

# Main.string_to_expr "x + y";;
- : Nano.expr = Nano.Bin (Nano.Var "x", Nano.Plus, Nano.Var "y")

# Main.string_to_expr "if x <= 4 then a || b else a && b";;
- : Nano.expr =
	Nano.If (Nano.Bin (Nano.Var "x", Nano.Le, Nano.Const 4),
	 Nano.Bin (Nano.Var "a", Nano.Or, Nano.Var "b"),
	 Nano.Bin (Nano.Var "a", Nano.And, Nano.Var "b"))

# Main.string_to_expr "if 4 <= z then 1-z else 4*z";;
- : Nano.expr =
	Nano.If (Nano.Bin (Nano.Const 4, Nano.Le, Nano.Var "z"),
	 Nano.Bin (Nano.Const 1, Nano.Minus, Nano.Var "z"),
	 Nano.Bin (Nano.Const 4, Nano.Mul, Nano.Var "z"))

# Main.string_to_expr "let a = 6 / 2 in a!=11";;
- : Nano.expr =
	Nano.Let ("a", Nano.Bin (Nano.Const 6, Nano.Div, Nano.Const 2),
	Nano.Bin (Nano.Var "a", Nano.Ne, Nano.Const 11))
~~~~~

### (d) 10 points

Add the following tokens to the lexer and parser.

| **String** | **Token** |
|:-----------|:----------|
|  `(`       |  `LPAREN` |
|  `)`       |  `RPAREN` |

Add rules to your parser to allow parenthesized expressions.  
In addition, add a rule to your parser for function application.  
Recall that function application is simply `"<expr> <expr>"`
which corresponds to calling the (function corresponding to the)
left expression with the (argument corresponding to the)
right expression.

Once you have implemented this functionality and recompiled,
you should get the following behavior at the `./nanoml.top`
prompt:

~~~~~{.ocaml}
# Main.token_list_of_string "() (  )";;
- : NanoParse.token list =
	[NanoParse.LPAREN; NanoParse.RPAREN; NanoParse.LPAREN; NanoParse.RPAREN]

# Main.string_to_expr "f x";;
- : Nano.expr = Nano.App (Nano.Var "f", Nano.Var "x")

# Main.string_to_expr "(fun x -> x+x) (3*3)";;
- : Nano.expr =
    Nano.App (Nano.Fun ("x", Nano.Bin (Nano.Var "x", Nano.Plus, Nano.Var "x")),
	Nano.Bin (Nano.Const 3, Nano.Mul, Nano.Const 3))

# Main.string_to_expr "(((add3 (x)) y) z)";;
- : Nano.expr =
	Nano.App (Nano.App (Nano.App (Nano.Var "add3", Nano.Var "x"), Nano.Var "y"),
	 Nano.Var "z")

# Main.filename_to_expr "tests/t1.ml";;
- : Nano.expr =
	Nano.Bin (Nano.Bin (Nano.Const 2, Nano.Plus, Nano.Const 3), Nano.Mul,
	Nano.Bin (Nano.Const 4, Nano.Plus, Nano.Const 5))

# Main.filename_to_expr "tests/t2.ml";;
- : Nano.expr =
	Nano.Let ("z1", Nano.Const 4,
	 Nano.Let ("z", Nano.Const 3,
	  Nano.Let ("y", Nano.Const 2,
	   Nano.Let ("x", Nano.Const 1,
	    Nano.Let ("z1", Nano.Const 0,
	     Nano.Bin (Nano.Bin (Nano.Var "x", Nano.Plus, Nano.Var "y"), Nano.Minus,
	      Nano.Bin (Nano.Var "z", Nano.Plus, Nano.Var "z1")))))))
~~~~~

### (d) 35 points

Restructure your parser to give binary operators the
following precedence and associativity.  This will
likely require that you add additional rules to your
parser, or see how to [add precedence and associativity to OcamlYacc](http://plus.kaist.ac.kr/~shoh/ocaml/ocamllex-ocamlyacc/ocamlyacc-tutorial/sec-ocamlyacc-declarations.html).


- (Highest) Fun Application
- `*`, `/`
- `+`, `-`
- `=`, `!=`, `<`, `<=`
- `&&`
- (Lowest) `||`


**Precedence** Function application having higher precedence than
multiplications, and multiplication higher than addition
means that `"1+f x*3"` should be parsed as if it were
`"1+((f x)*3)"`.

**Associativity** All binary operators are *left associative**
meaning that `"1-2-3-4"` should be parsed as if it were `"((1-2)-3)-4"`,
and `"f x y z"` should be parsed as if it were `"((f x) y) z"`.

Once you have implemented this functionality and recompiled,
you should get the following behavior at the `./nanoml.top`
prompt:


~~~~~{.ocaml}
# Main.string_to_expr "1-2-3-4";;
- : Nano.expr =
	Nano.Bin
	 (Nano.Bin (Nano.Bin (Nano.Const 1, Nano.Minus, Nano.Const 2),
	  Nano.Minus,
	   Nano.Const 3),
	 Nano.Minus, Nano.Const 4)

# Main.string_to_expr "1+a&&b||c+d*e-f/g x";;
- : Nano.expr =
	Nano.Bin
	 (Nano.Bin (Nano.Bin (Nano.Const 1, Nano.Plus, Nano.Var "a"), Nano.And,
	   Nano.Var "b"),
	 Nano.Or,
	 Nano.Bin
	  (Nano.Bin (Nano.Var "c", Nano.Plus,
	    Nano.Bin (Nano.Var "d", Nano.Mul, Nano.Var "e")),
	  Nano.Minus,
	  Nano.Bin (Nano.Var "f", Nano.Div, Nano.App (Nano.Var "g", Nano.Var "x"))))

# Main.filename_to_expr "tests/t13.ml";;
- : Nano.expr =
	Nano.Let ("f",
	 Nano.Fun ("x",
	  Nano.Fun ("y",
	   Nano.Fun ("a",
	    Nano.Bin (Nano.App (Nano.Var "a", Nano.Var "x"), Nano.Mul, Nano.Var "y")))),
	 Nano.Let ("g",
	  Nano.Fun ("x",
	   Nano.Bin (Nano.Var "x", Nano.Plus,
	    Nano.Bin (Nano.Const 1, Nano.Mul, Nano.Const 3))),
	  Nano.App (Nano.App (Nano.App (Nano.Var "f", Nano.Const 7), Nano.Const 8),
	   Nano.Var "g")))
~~~~~

### (e) 15 points

<p>Add the following tokens to the lexer and parser.

<table border="1">
	<tr><th>String</th><th>Token</th></tr>
	<tr><td><tt>[</tt></td><td><tt>LBRAC</tt></td></tr>
	<tr><td><tt>]</tt></td><td><tt>RBRAC</tt></td></tr>
	<tr><td><tt>;</tt></td><td><tt>SEMI</tt></td></tr>
	<tr><td><tt>::</tt></td><td><tt>COLONCOLON</tt></td></tr>
</table>

Add rules to your lexer and parser to support parsing lists.
`"[a;b;c;d;e;f;g]"` should be parsed as if it were
`"a::b::c::d::e::f::g::[]"`. The `::` operator should
have higher priority than the comparison functions (`=`, `<=` etc.),
and lower priority than `+` and `-`.  In addition, `::`
should be right associative.  `"[]"` should be parsed as
`NilExpr`, and `::` should be treated as any other
binary operator.

Once you have implemented this functionality and recompiled,
you should get the following behavior at the `./nanoml.top`
prompt:

~~~~~{.ocaml}
# Main.string_to_expr "1::3::5::[]";;
- : Nano.expr =
	Nano.Bin (Nano.Const 1, Nano.Cons,
	 Nano.Bin (Nano.Const 3, Nano.Cons,
	  Nano.Bin (Nano.Const 5, Nano.Cons, Nano.NilExpr)))

# Main.string_to_expr "[1;3;5]";;
- : Nano.expr =
	Nano.Bin (Nano.Const 1, Nano.Cons,
	 Nano.Bin (Nano.Const 3, Nano.Cons,
	  Nano.Bin (Nano.Const 5, Nano.Cons, Nano.NilExpr)))

# Main.string_to_expr "1::3::5::[] = [1;3;5]";;
- : Nano.expr =
	Nano.Bin
	 (Nano.Bin (Nano.Const 1, Nano.Cons,
	   Nano.Bin (Nano.Const 3, Nano.Cons,
	    Nano.Bin (Nano.Const 5, Nano.Cons, Nano.NilExpr))),
	 Nano.Eq,
	 Nano.Bin (Nano.Const 1, Nano.Cons,
	  Nano.Bin (Nano.Const 3, Nano.Cons,
	   Nano.Bin (Nano.Const 5, Nano.Cons, Nano.NilExpr))))
~~~~~


## Problem 3: NanoML Executable

Once you have completed the first two parts, you should end up
with an executable `nanoml.byte`.  You should be able to test it
as follows from the unix shell prompt:

~~~~~{.ocaml}
$ ./nanoml.byte tests/t1.ml
...
out: 45

$./nanoml.byte tests/t2.ml
...
out: 0

$ ./nanoml.byte tests/t3.ml
...
out: 2
~~~~~

and so forth, for all the files in tests.  To get the expected
(i.e. "correct") value for the other tests, run them with Ocaml:

~~~~~{.ocaml}
# #use "tests/t1.ml";;
- : int = 45
~~~~~

and so forth.  "tests/t14.ml" requires that you have completed
both extra credit parts.

**We strongly encourage you to make sure that your `nanoml.byte`
produces exactly the same answer as the "real" Ocaml for each of
the files in `tests/`**
