---
title: A Quick Tutorial On Parsing
---

In this note we consider an invaluable programming tool, the 
*parser generator*. The problem that we want to solve 
is: how do we **parse strings**, that is, convert 
(unstructured) strings, the lowest-level representation of a 
program text, into (highly structured) representations like 
expressions, statements, functions *etc* which  can then be 
compiled or interpreted.

Of course, the problem is much more general and arises in 
pretty much every large scale system, how do you convert 
raw data strings, into structured objects that can be 
manipulated by the rest of the system.

Of course, one can imagine various convoluted algorithms 
for extracting structure from strings. Indeed, you may well
think that the conversion routine depends heavily on the
*target* of the conversion! However, it turns out that we 
can design a small *domain-specific language* that describes
a large number of the kinds of target structures, and we 
will use a *parser generator* that will automatically 
convert the structure description into a parsing function!

# An Arithmetic Interpreter

As a running example, let us build a small interpreter for 
a language of arithmetic expressions, described by the type

~~~~~{.ocaml}
type aexpr =
  | Const of int
  | Var of string
  | Plus of aexpr * aexpr
  | Minus of aexpr * aexpr
  | Times of aexpr * aexpr
  | Divide of aexpr * aexpr
~~~~~

shown in file (arithInterpreter.ml)[0]. This expression language 
is quite similar to what you saw for the random-art assignment, 
and we can write a simple recursive evaluator for it

~~~~~{.ocaml}
let rec eval env = function
  | Const i -> i
  | Var s -> List.assoc s env
  | Plus (e1, e2) -> eval env e1 + eval env e2
  | Minus (e1, e2) -> eval env e1 - eval env e2
  | Times (e1, e2) -> eval env e1 * eval env e2
  | Divide (e1, e2) -> eval env e1 / eval env e2
~~~~~

Here the `env` is a `(string * int) list` corresponding to a list 
of variables and their corresponding values. Thus, if you run the above,
you would see something like

~~~~~{.ocaml}
# eval [] (Plus (Const 2, Const 6)) ;;
- : int = 4

# eval [("x",16); ("y", 10)] (Minus (Var "x", Var "y")) ;;
- : int = 6

# eval [("x",16); ("y", 10)] (Minus (Var "x", Var "z")) ;;
Exception: NotFound.
~~~~~~

Now it is rather tedious to write ML expressions like 
`Plus (Const 2, Const 6)`, and `Minus (Var "x", Var "z")`. 
We would like to obtain a simple parsing function 

~~~~~{.ocaml}
val parseAexpr : string -> aexpr
~~~~~

that converts a string to the corresponding `aexpr` if possible. For
example, it would be sweet if we could get

~~~~~{.ocaml}
# parseAexpr "2 + 6" ;;
- : aexpr = Plus (Const 2, Const 6)

# parseAexpr "(x - y) / 2" ;;
- : aexpr = Divide (Minus (Var "x", Var "y"), Const 2)
~~~~~

and so on. Lets see how to get there.

# Strategy

We will use a two-step strategy to convert raw strings into structured
data.

## Step 1 (Lexing) : From String to Tokens

Strings are really just a list of very low-level characters.
In the first step, we will aggregate the characters into more 
meaningful *tokens* that contain more high-level information. 
For example, we will can aggregate a sequence of numeric characters 
into an integer, and a sequence of alphanumerics (starting with a
lower-case alphabet) into say a variable name. 

Thus, as a result of the lexing phase, we can convert a list of
individual characters

<img src="../static/info_parser.001a.jpg" width="300"/>

into a list of *tokens*

<img src="../static/info_parser.001b.jpg" width="300"/>

### Step 2 (Parsing) : From Tokens to Tree 

Next, we will use a special description of the structures we 
are trying to generate called a *grammar* to convert the list 
of tokens into a tree-like representation of our final structure.
The actual algorithms for converting from lists of tokens to 
trees are very subtle and sophisticated. We will omit a detailed 
description and instead just look at how the structures can 
themselves be represented by grammars.

Next, we get into the details of our the above strategy, by 
describing exactly what the lexer and parser (generators) do 
in terms of their input and output. 

# Lexers

We will use the tool called `ocamllex` to automatically obtain
a lexer from a high-level description of what the tokens are and
what what sequences of characters should get mapped to tokens.

## Tokens 

The file (arithParser0.mly)[1] describes the set of tokens needed 
to represent our simple language

~~~~~{.ocaml}
%token <int> CONST
%token <string> VAR
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN
%token EOF
~~~~~

Note that the first two tokens, `CONST` and `VAR` also carry values with
them, respectively `int` and `string.


## Regular Expressions

Next, we must describe the sequences of characters that get aggregated
into a particular token. This is done using (regular expressions)[7]
defined in the file (arithLexer.mll)[2].

~~~~~{.ocaml}
{ open ArithParser }

rule token = parse
  | eof                      { EOF }
  | [' ' '\t' '\r' '\n']     { token lexbuf } 
  | ['0'-'9']+ as l          { CONST (int_of_string l) }
  | ['a'-'z']['A'-'z']* as l { VAR l }
  | '+'                      { PLUS }
  | '-'                      { MINUS }
  | '*'                      { TIMES }
  | '/'                      { DIVIDE }
  | '('                      { LPAREN }
  | ')'                      { RPAREN }
~~~~~

the first line at top simply imports the token definitions from
`arithParser.mly`. Next, there is a sequence of rules of the form
`| <regexp>	{ml-expr}`.

Intuitively, each regular expression describes a sequence of characters,
and when that sequence is matched in the input string, the corresponding ML
expression is evaluated to obtain the token that is to be returned on the
match. Let's see some examples,

~~~~~{.ocaml}
  | eof                      { EOF }
  | '+'                      { PLUS }
  | '-'                      { MINUS }
  | '*'                      { TIMES }
  | '/'                      { DIVIDE }
  | '('                      { LPAREN }
  | ')'                      { RPAREN }
~~~~~

- when the `eof` is reached (i.e. we hit the end of the string), a token 
  called `EOF`  is generated, similarly, when a character `+`, `-`, `/` 
  etc. are encountered, the lexer generates the tokens `PLUS`, `MINUS`, 
  `DIVIDE` etc. respectively,

~~~~~{.ocaml}
  | [' ' '\t' '\r' '\n']     { token lexbuf } 
~~~~~

- `[c1 c2 ... cn]` where each `ci` is a character denotes a regular expression
  that matches **any of** the characters in the sequence. Thus, the regexp 
  `[' ' '\n' '\t']` indicates that if  either a blank or tab or newline is 
  hit, the lexer should simply ignore it and recursively generate the token
  corresponding to the rest of the buffer, 

~~~~~{.ocaml}
  | ['0'-'9']+ as l          { CONST (int_of_string l) }
~~~~~

- `['0' - '9']` denotes a regexp that matches any
  digit-character. When you take a regexp and put a `+` in front of it, 
  i.e. `e+` you get a regexp corresponding to a **non-zero repetitions` of `e`. 
  Thus, the regexp `['0'-'9']+` matches a non-empty sequence of digit characters! 
  Here, the variable `l` holds the exact substring that was matched, and we 
  simply write `CONST (int_of_string l)` to return the `CONST` token carrying 
  the `int` value corresponding to the matched substring. 

~~~~~{.ocaml}
  | ['a'-'z']['A'-'z' '0'-'9'] as l { VAR l }
~~~~~

- A regexp of the form `e1 e2` matches any string `s` that can be split into 
  two parts `s1` and `s2` (s.t. `s == s1 ^ s2`) where `s1` matches `e1` and 
  `s2` matches `e2`. That is, `e1 e2` is a **sequencing** regexp that first
  matches `e1` and then matches `e2`. The regexp `e*` corresponds to
  **zero-or-more repetitions** of `e`. Thus, `['a'-'z']['A'-'z' '0'-'9']*`
  is a regexp that matches all strings that begin with a lower-case
  alphabet, and then have a (possibly empty) sequence of alpha-numeric
  characters. As before, the entire matching string is bound to the 
  variable `l` and in the case the `VAR l` token is returned indicating
  that an identifier appeared in the input stream.

## Running the Lexer

We can run the lexer directly to look at the sequences of tokens found.
The function `Lexing.from_string` simply converts an input string into a
buffer on which the actual lexer operates.

~~~~~{.ocaml}
# ArithLexer.token (Lexing.from_string "+");;
- : ArithParser.token = ArithParser.PLUS 

# ArithLexer.token (Lexing.from_string "294");;
- : ArithParser.token = ArithParser.CONST 294
~~~~~

Next, we can write a function that recursively keeps grinding away to get
all the possible tokens from a string (until it hits `eof`). When we call
that function it behaves thus:

~~~~~{.ocaml}
# token_list_of_string "23 + + 92 zz /" ;;
- : ArithParser.token list =
  [ArithParser.CONST 23; ArithParser.PLUS; ArithParser.PLUS;
   ArithParser.CONST 92; ArithParser.VAR "zz"; ArithParser.DIVIDE]

# token_list_of_string "23++92zz/" ;;
- : ArithParser.token list =
  [ArithParser.CONST 23; ArithParser.PLUS; ArithParser.PLUS;
   ArithParser.CONST 92; ArithParser.VAR "zz"; ArithParser.DIVIDE]
~~~~~

Note that the above two calls produce exactly the same result, because 
the lexer finds maximal matches.

~~~~~{.ocaml}
# token_list_of_string "92z" ;;
- : ArithParser.token list = [ArithParser.CONST 92; ArithParser.VAR "z"]
~~~~~

Here, when it hits the `z` it knows that the number pattern has ended and
a new variable pattern has begun. Of course, if you give it something that
doesn't match anything, you get an exception

~~~~~{.ocaml}
# parse_string "%" ;;
Exception: Failure "lexing: empty token".
~~~~~

# Parsers

Next, will use the tool called `ocamlyacc` to automatically obtain
a parser from a high-level description of the target structure 
called a **grammar**. (Note: grammars are very deep area of study, 
we're going to take a very superficial look here, guided by the pragmatics
of how to convert strings to `aexpr` values.)

## Grammars

A grammar is a recursive definition of a set of trees, comprising

- Non-terminals and Terminals, which describe the internal and leaf
  nodes of the tree, respectively. Here, the leaf nodes will be tokens.

- Rules of the form

~~~~~{.ocaml}
nonterm :
  | term-or-nonterm-1 ... term-or-non-term-n { ML-EXPR }
~~~~~
   
  that describe the possible configuration of 
  children of each internal node, together with an ML 
  expression that generates a *value* that is used to 
  decorate the node. This value is computed from the 
  values decorating the respective children.

We can define the following simple grammar for arith expressions:

~~~~~{.ocaml}
aexpr:
  | aexpr PLUS   aexpr        { Plus ($1, $3)   }
  | aexpr MINUS  aexpr        { Minus ($1, $3)  }
  | aexpr TIMES  aexpr        { Times ($1, $3)  }
  | aexpr DIVIDE aexpr        { Divide ($1, $3) }
  | CONST                     { Const $1        }
  | VAR                       { Var $1          }
  | LPAREN aexpr RPAREN       { $2              }
~~~~~

Note that the above ``grammar" (almost) directly mimics the 
recursive type definition of the expressions.  In the above
grammar, the *only* non-terminal is `aexpr` (we could call 
it whatever we like, we just picked the same name for 
convenience.)
The terminals are the tokens we defined earlier, and each
rule corresponds to how you would take the sub-trees (i.e. 
sub-expressions) and stitch them together to get bigger trees.

The line `%type <ArithInterpreter.aexpr> aexpr` at the top stipulates
that each `aexpr` node will be decorated with a value of type
`ArithInterpreter.aexpr` -- that is, by a structured arithmetic expression.

Next, let us consider each of the rules in turn.

~~~~~{.ocaml}
  | CONST                     { Const $1        }
  | VAR                       { Var $1          }
~~~~~

- The base-case rules for `CONST` and `VAR` state that those 
  (individual) tokens can be viewed as corresponding to `aexpr`
  nodes. Consider the target expression in the curly braces.  
  Here `$1` denotes the value decorating the 1st (and only!) 
  element of the corresponding non/terminal- sequence. That is, 
  for the former (respectively latter) case $1 the `int` 
  (respectively `string` value) associated with the token,
  which we use to obtain the base arithmetic expressions via the 
  appropriate constructors. 

~~~~~{.ocaml}
  | aexpr PLUS   aexpr        { Plus ($1, $3)   }
  | aexpr MINUS  aexpr        { Minus ($1, $3)  }
  | aexpr TIMES  aexpr        { Times ($1, $3)  }
  | aexpr DIVIDE aexpr        { Divide ($1, $3) }
~~~~~

- The inductive case rules, e.g. for the `PLUS` case says that 
  if there is a token-sequence that is parsed into an `aexpr` 
  node, followed by a `PLUS` token, followed by a sequence that
  is parsed into an `aexpr` node, then the **entire** sequence 
  can be parsed into an `aexpr` node.
  Here `$1` and `$3` refer to the first and third elements of 
  the sequence, that is, the *left* and *right* subexpressions.
  The decorated value is simply the super-expression obtained by
  applying the `Plus` constructor to the left and right subexpressions.
  The same applies to 

~~~~~{.ocaml}
  | LPAREN aexpr RPAREN       { $2              }
~~~~~

- The last rule allows us to parse parenthesized expressions; 
  if there is a left-paren token followed by an expresssion 
  followed by a matching right-paren token, then the whole 
  sequence is an `aexpr` node. Notice how the decorated expression is
  simply `$2` which decorates the second element of the sequence, i.e.
  the (sub) expression being wrapped in parentheses.

## Running the Parser

Great, lets take our parser out for a spin! First, lets build the different
elements

~~~~~{.ocaml}
$ cp arithParser0.mly arithParser.mly

$ make clean
rm -f *.cm[io] arithLexer.ml arithParser.ml arithParser.mli

$ make 
ocamllex arithLexer.mll
11 states, 332 transitions, table size 1394 bytes
ocamlyacc arithParser.mly
16 shift/reduce conflicts.
ocamlc -c arithInterpreter.ml
ocamlc -c arithParser.mli
ocamlc -c arithLexer.ml
ocamlc -c arithParser.ml
ocamlc -c arith.ml
ocamlmktop arithLexer.cmo arithParser.cmo arithInterpreter.cmo arith.cmo -o arith.top
~~~~~

Now, we have a specialize top-level with the relevant libraries baked in.
So we can do:

~~~~~{.ocaml}
$ rlwrap ./arith.top 
        Objective Caml version 3.11.2

# open Arith;;

# eval_string [] "1 + 3 + 6" ;;
- : int = 10

# eval_string [("x", 100); ("y", 20)] "x - y" ;;
- : int = 80
~~~~~

And lo! we have a simple calculator that also supports variables.

## Precedence and Associativity 

Ok, looks like our calculator works fine, but lets try this

~~~~~{.ocaml}
# eval_string [] "2 * 5 + 5" ;;
- : int = 20
~~~~~

Huh?! you would think that the above should yield `15` as `*` has higher
precedence than `+` , and so the above expression is really `(2 * 5) + 5`.
Indeed, if we took the trouble to put the parentheses in, the right thing
happens

~~~~~{.ocaml}
# eval_string [] "(2 * 5) + 5" ;;
- : int = 15 
~~~~~

Indeed, the same issue arises with a single operator

~~~~~{.ocaml}
# eval_string [] "2 - 1 - 1" ;;
- : int = 2 
~~~~~

What happens here is that the grammar we gave is **ambiguous**
as there are multiple ways of parsing the string `2 * 5 + 5`, namely

- `Plus (Times (Const 2, Const 5), Const 5)`, or
- `Times (Const 2, Plus (Const 5, Const 5))`

We want the former, but ocamlyacc gives us the latter!
Similarly, there are multiple ways of parsing `2 - 1 - 1`, namely

- `Minus (Minus (Const 2, Const 1), Const 1)`, or
- `Minus (Const 2, Minus (Const 1, Const 1))`

Again, since `-` is left-associative, we want the former, but 
we get the latter! (Incidentally, this is why we got those wierd
grumbles about `shift/reduce conflicts` when we ran `ocamlyacc`
above, but lets not go too deep into that...)

There are various ways of adding precedence, one is to hack the grammar 
by adding various extra non-terminals, as done here (arithParser2.mly)[5].
Note how there are no conflicts if you use that grammar instead.

However, since this is such a common problem, there is a much simpler
solution, which is to add precedence and associativity annotations to the
.mly file. In particular, let us use the modified grammar 
(arithParser1.mly)[3]. 

~~~~~{.ocaml}
$ cp arithParser1.mly arithParser.mly
$ make
ocamllex arithLexer.mll
11 states, 332 transitions, table size 1394 bytes
ocamlyacc arithParser.mly
ocamlc -c arithInterpreter.ml
ocamlc -c arithParser.mli
ocamlc -c arithLexer.ml
ocamlc -c arithParser.ml
ocamlc -c arith.ml
ocamlmktop arithLexer.cmo arithParser.cmo arithInterpreter.cmo arith.cmo -o arith.top
~~~~~

check it out, no conflicts this time! The only difference between this 
grammar and the previous one are the lines

~~~~~{.ocaml}
%left PLUS MINUS
%left TIMES DIVIDE
~~~~~

This means that all the operators are **left-associative**  
so `e1 - e2 - e3` is parsed as if it were `(e1 - e2) - e3`. 
As a result we get

~~~~~{.ocaml}
# eval_string []  "2 - 1 - 1" ;;
- : int = 0
~~~~~

Furthermore, we get that addition and subtraction have lower
precedence than multiplication and division (the order of 
the annotations matters!)

~~~~~{.ocaml}
# eval_string []  "2 * 5 + 5" ;;
- : int = 15
# eval_string []  "2 + 5 * 5" ;;
- : int = 27
~~~~~

Hence, the multiplication operator has higher precedence than the addition,
as we have grown to expect, and all is well in the world.


This concludes our brief tutorial, which should suffice for your NanoML
programming assignment. However, if you are curious, I encourage you to
look at (this)[6] for more details.


[0]: ($root/static/pa4/arith_notes/arithInterpreter.ml) 
[1]: ($root/static/pa4/arith_notes/arithParser0.mly) 
[2]: ($root/static/pa4/arith_notes/arithLexer.mll) 
[3]: ($root/static/pa4/arith_notes/arithParser1.mly) 
[6]: http://plus.kaist.ac.kr/~shoh/ocaml/ocamllex-ocamlyacc/ocamlyacc-tutorial/
[7]: http://en.wikipedia.org/wiki/Regular_expression

