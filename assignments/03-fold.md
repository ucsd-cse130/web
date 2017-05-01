---
title: HW 3, due 5/10/2017 (160 pts)
headerImg: angles.jpg
---

## Due by 23:59:59 pm on Wednesday, May 10, 2017

## Overview

The overall objective of this assignment is to expose you
to fold, *fold*, and more **fold**. And just when you think
you've had enough, **FOLD**.

The assignment is in the file

- [hw3.ml](/static/raw/hw3.ml)

that you need to download, edit and submit. As before,
your task is to replace each expression of the form

~~~~~{.ocaml}
failwith "to be written"
~~~~~

with the the appropriate OCaml code for each of those expressions.

**Note:** All the solutions can be done using the purely
functional fragment of OCaml, using constructs covered
in class, and most require the use of **recursion**.
Solutions using imperative features such as references,
while loops or library functions will receive **no credit**
It is a good idea to start this assignment early; ML
programming, while quite simple (when you know how),
often seems somewhat foreign at first, particularly
when it comes to recursion and list manipulation.


## Assignment Testing and Evaluation

Your functions/programs **must** compile and run with `ocaml` on `ieng6.ucsd.edu`.

Most of the points, will be awarded automatically, by
**evaluating your functions against a given test suite**.
[hw1.ml](/static/raw/hw1.ml) contains a very small suite
of tests which gives you a flavor of of these tests.

At any point, on the bash shell, enter:

```ocaml
$ ocaml hw1.ml
```

or if you are in the Ocaml REPL enter:

```ocaml
# #use "hw1.ml" ;;
```

to get a report on how your code stacks
up against the simple tests.

The last line of the shell must look like:

~~~~~
130>>Compiled

- : int * int = (SCORE, TOTAL)
~~~~~

where `SCORE` and `TOTAL` are a pair of integers,
reflecting your score and the max possible score
on the sample tests.

**If instead an error message appears, your code will receive a zero.**

If for some problem, you cannot get the code to compile, leave it as is with
the `failwith ...` with your partial solution enclosed below as a comment.

The other lines will give you a readout for each test. You are encouraged to
try to understand the testing code, but you will not be graded on this.

## Submission Instructions

To submit your homework (on `ieng6`), enter:

```bash
$ turnin -c cs130s -p 03 hw3.ml
```

`turnin` will provide you with a confirmation of the
submission process; make sure that the size of the file
indicated by `turnin` matches the size of your file.
See the ACS Web page on [turnin](http://acs.ucsd.edu/info/turnin.php)
for more information on the operation of the program.

## Problem #1: Warm-Up

### (a) 15 points
Fill in the skeleton given for `sqsum`,
which uses `List.fold_left` to get an OCaml
function

~~~~~{.ocaml}
val sqsum : int list -> int
~~~~~

such that `sqsum [x1;...;xn]` returns the integer `x1^2 + ... + xn^2`

Your task is to fill in the appropriate values for

1. the folding function `f` and
2. the base case `base`.

Once you have implemented the function, you should get
the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# sqsum [];;
- : int = 0

# sqsum [1;2;3;4];;
- : int = 30

# sqsum [(-1); (-2); (-3); (-4)];;
- : int = 30
~~~~~


### (b) 30 points
Fill in the skeleton given for `pipe` which uses `List.fold_left`
to get an OCaml function

~~~~~{.ocaml}
val pipe : ('a -> 'a) list -> ('a -> 'a)
~~~~~

such that `pipe [f1;...;fn]` (where `f1,...,fn` are functions!)
returns a function `f` such that for any `x`, we have `f x`
returns result `fn(...(f2(f1 x)))`.

Again, your task is to fill in the appropriate values for

1. the folding function `f` and
2. the base case `base`.

Once you have implemented the function, you should get
the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# pipe [] 3;;
- :  int =  3
# pipe [(fun x -> x+x); (fun x -> x + 3)] 3 ;;
- :  int =  9
# pipe [(fun x -> x + 3);(fun x-> x + x)] 3;;
- :  int =  12
~~~~~

### (c) 20 points

Fill in the skeleton given for `sepConcat`,
which uses `List.fold_left` to get an OCaml function

~~~~~{.ocaml}
val sepConcat : string -> string list -> string
~~~~~

Intuitively, the expression `sepConcat sep [s1;...;sn]`
where `sep` is a string to be used as a separator, and
`[s1;...;sn]` is a list of strings.
`sepConcat sep []` should return the empty string `""`.
`sepConcat sep [s]` should return just the string `s`.
Otherwise, if there are more than one string, in the list,
then the output should be the string
`s1 ^ sep ^ s2 ^ ... ^ sep ^ sn`.
You should only modify the parts of the skeleton consisting
of `failwith "to be implemented"`. You will need to
define the function `f`, and give values for `base` and `l`.

Once you have filled in these parts, you should get the
following behavior at the OCaml prompt:

~~~~~{.ocaml}
# sepConcat ", " ["foo";"bar";"baz"];;
- : string = "foo, bar, baz"

# sepConcat "---" [];;
- : string = ""

# sepConcat "" ["a";"b";"c";"d";"e"];;
- : string = "abcde"

# sepConcat "X" ["hello"];;
- : string = "hello"
~~~~~

### (d) 10 points

Implement the curried OCaml function

~~~~~{.ocaml}
val stringOfList : ('a -> string) -> 'a list -> string
~~~~~

such that `stringOfList f [x1;...;xn]` should return the string
`"[" ^ (f x1) ^ "; " ^ ... ^ (f xn) ^ "]"`

This function can be implemented on one line,
**without using any recursion** by calling `List.map`
and `sepConcat` with appropriate inputs.
Once you have completed this function, you should get the
following behavior at the OCaml prompt:

~~~~~{.ocaml}
# stringOfList string_of_int [1;2;3;4;5;6];;
- : string = "[1; 2; 3; 4; 5; 6]"

# stringOfList (fun x -> x) ["foo"];;
- : string = "[foo]"

# stringOfList (stringOfList string_of_int) [[1;2;3];[4;5];[6];[]];;
- : string = "[[1; 2; 3]; [4; 5]; [6]; []]"
~~~~~


## Problem #2: Big Numbers

The OCaml type `int` only contains values upto a certain size.
For example,

~~~~~{.ocaml}
# 99999999999999999999999999999999999999999999999 ;;
Error: Integer literal exceeds the range of representable integers of type int
~~~~~

You will now implement functions to manipulate arbitrarily large
numbers represented as *lists of integers*.

### (a) 10 + 5 + 10 points

Write a curried function

~~~~~{.ocaml}
val clone : 'a -> int -> 'a list
~~~~~

such that `clone x n` returns a list of `n` copies of the value `x`.
If the integer `n` is `0` or negative, then `clone` should return
the empty list.  Once you have implemented the function, you should
get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# clone 3 5;;
- :  int list = [3; 3; 3; 3; 3]

# clone "foo" 2;;
- :  string list = ["foo"; "foo"]

# clone clone (-3);;
- :  ('_a -> int -> '_a list) list = []
~~~~~

Use `clone` to write a curried function

~~~~~{.ocaml}
val padZero : int list -> int list -> int list  * int list
~~~~~

which takes two lists: `[x1;...;xn]` `[y1;...;ym]` and
adds zeros in front of the shorter list to make the lists
equal.

Your implementation should *not** be recursive.

Once you have implemented the function, you should
get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# padZero [9;9] [1;0;0;2];;
- :  int list * int list   =  ([0;0;9;9],[1;0;0;2])

# padZero [1;0;0;2] [9;9];;
- :  int list * int list =  ([1;0;0;2],[0;0;9;9])
~~~~~

Next, write a function

~~~~~{.ocaml}
val removeZero : int list -> int list
~~~~~

that takes a list and removes a prefix of leading zeros.

Once you have implemented the function, you should get the
following behavior at the OCaml prompt:

~~~~~{.ocaml}
# removeZero [0;0;0;1;0;0;2];;
- :  int list    =  [1;0;0;2]

# removeZero [9;9];;
- :  int list =  [9;9]

# removeZero [0;0;0;0];;
- :  int list =  []
~~~~~

### (b) 25 points

Let us use the list `[d1;d2;...;dn]`, where each `di`
is between `0` and `9`, to represent the (positive)
**big-integer** `d1d2...dn`. For example, let
`[9;9;9;9;9;9;9;9;9;9]` represent the big-integer `9999999999`.
Fill out the implementation for

~~~~~{.ocaml}
val bigAdd : int list -> int list -> int list
~~~~~

so that it takes two integer lists, where each integer is
between `0` and `9` and returns the list corresponding to
the addition of the two big-integers. Again, you have to
fill in the implementation to supply the appropriate values
to `f`, `base`, `args`. Once you have implemented the function,
you should get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# bigAdd [9;9] [1;0;0;2];;
- :  int list   =  [1;1;0;1]

# bigAdd [9;9;9;9] [9;9;9];;
- :  int list  =  [1;0;9;9;8]
~~~~~

### (c) 15 + 20 points

Next you will write functions to multiply two big integers.
First write a function

~~~~~{.ocaml}
val mulByDigit : int -> int list -> int list
~~~~~

which takes an integer digit and a big integer, and returns the
big integer list which is the result of multiplying the big
integer with the digit. Once you have implemented the function,
you should get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# mulByDigit 9 [9;9;9;9];;
- :  int list  =  [8;9;9;9;1]
~~~~~

Now, using `mulByDigit`, fill in the implementation of

~~~~~{.ocaml}
val bigMul : int list -> int list -> int list
~~~~~

Again, you have to fill in implementations for `f` , `base` , `args` only.
Once you are done, you should get the following behavior at the prompt:

~~~~~{.ocaml}
# bigMul [9;9;9;9] [9;9;9;9];;
- :  int list  =  [9;9;9;8;0;0;0;1]

# bigMul [9;9;9;9;9] [9;9;9;9;9];;
- :  int list  =  [9;9;9;9;8;0;0;0;0;1]
~~~~~
