---
title: HW 1, due 4/24/2017 (65pts)
headerImg: angles.jpg
---


## Due by 23:59:59 pm on Monday, April 24th, 2017

## Running Ocaml

Use `ocaml` on [ieng6](lectures/info_ocaml.html) to **edit**, **run** and **submit** the code.

## Overview

The objective of this assignment is for you to gain some
hands-on experience with OCaml. All the problems require
relatively little code ranging from 2 to 15 lines.
If any function requires more than that, you can be
sure that you need to rethink your solution.

The assignment is in the single file

- [hw1.ml](/static/raw/hw1.ml)

that you need to download, if you wish, by using `wget`:

```bash
$ wget https://ucsd-cse130.github.io/web/static/raw/hw1.ml
```

The file contains:

1. **skeleton functions** with missing bodies that you will fill in,
2. **sample tests**, and,
3. **testing code** that you will use to check your assignments before submitting.

You should only need to modify the first part of the file, which
has expressions of the form:

~~~~~{.ocaml}
failwith "TBD: ..."
~~~~~

Your task is to replace those expressions with the appropriate Ocaml
implementations.

**Note:** All the solutions can be done using the purely
functional fragment of OCaml, using constructs covered
in class, and most require the use of **recursion**.
Solutions using imperative features such as references,
while loops or library functions (other than those
explicitly allowed) will receive **no credit.**
It is a good idea to start this assignment early; ML
programming, while quite simple, when you know how,
may seem somewhat foreign at first, particularly
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
$ turnin -c cs130s -p 01 hw1.ml
```

`turnin` will provide you with a confirmation of the
submission process; make sure that the size of the file
indicated by `turnin` matches the size of your file.
See the ACS Web page on [turnin](http://acs.ucsd.edu/info/turnin.php)
for more information on the operation of the program.


## Problem 1: [Digital Roots and Additive Persistence](http://mathworld.wolfram.com/AdditivePersistence.html)


### (a) 10 points

Write an OCaml function

~~~~~{.ocaml}
val sumList : int list -> int
~~~~~

that such that `sumList xs` returns the sum of the integer elements of
`xs`. Once you have implemented the function, you should get the following
behavior at the OCaml prompt:

~~~~~{.ocaml}
# sumList [1; 2; 3; 4];;
- : int = 10

# sumList [1; -2; 3; 5];;
- : int = 7

# sumList [1; 3; 5; 7; 9; 11];;
- : int = 36
~~~~~

## (b) 10 points

Write an OCaml function

~~~~~{.ocaml}
val digitsOfInt : int -> int list
~~~~~

such that `digitsOfInt n` returns `[]` if `n` is not positive,
and returns the list of digits of `n` in the order in which
they appear in `n`. Once you have implemented the function,
you should get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# digitsOfInt 3124;;
- : int list = [3; 1; 2; 4]

# digitsOfInt 352663;;
- : int list = [3; 5; 2; 6; 6; 3]
~~~~~

### (c) 10+10 points

Consider the process of taking a number, adding its digits,
then adding the digits of the number derived from it, etc.,
until the remaining number has only one digit.
The number of additions required to obtain a single digit
from a number `n` is called the *additive persistence* of `n`,
and the digit obtained is called the <i>digital root</i> of `n`.

For example, the sequence obtained from the starting number
`9876` is `9876`, `30`, `3`, so `9876` has an additive
persistence of `2` and a digital root of `3`.

Write two OCaml functions

~~~~~{.ocaml}
val additivePersistence : int -> int
val digitalRoot         : int -> int
~~~~~

that take positive integer arguments `n` and return respectively
the additive persistence and the digital root of `n`. Once you
have implemented the functions, you should get the following
behavior at the OCaml prompt:

~~~~~{.ocaml}
# additivePersistence 9876;;
- : int = 2

# digitalRoot 9876;;
- : int = 3
~~~~~

## Problem 2: Palindromes

### (a) 15 points

Without using any built-in OCaml functions, write an OCaml
function:

~~~~~{.ocaml}
val listReverse : 'a list -> 'a list
~~~~~

such that `listReverse xs` returns the list of elements of `xs` in the
reversed order (in which the appear in `xs`.) Once you have implemented
the function, you should get the following behavior at the OCaml prompt:

~~~~~{.ocaml}
# listReverse [1; 2; 3; 4];;
- : int list = [4; 3; 2; 1]

# listReverse ["a"; "b"; "c"; "d"];;
- : string list = ["d"; "c"; "b"; "a"]
~~~~~



###(b) 10 points

A *palindrome* is a word that reads the same from left-to-right and
right-to-left. Write an OCaml function

~~~~~{.ocaml}
val palindrome : string -> bool
~~~~~

such that `palindrome w` returns `true` if the string is a palindrome and
`false` otherwise. You may use the given helper function `explode`.
Once you have implemented the function, you should get the following
behavior at the OCaml prompt:

~~~~~{.ocaml}
# palindrome "malayalam";;
- : bool = true
# palindrome "myxomatosis";;
- : bool = false
~~~~~
