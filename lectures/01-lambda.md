---
title: Lambda Calculus
headerImg: sea.jpg
---

## The Smallest Universal Language

![Alonzo Church](https://upload.wikimedia.org/wikipedia/en/a/a6/Alonzo_Church.jpg)

Developed in 1930s by Alonzo Church

- Studied in logic and computer science

Test bed for procedural and functional PLs

- Simple, Powerful, Extensible

## The Next 700 Languages

![Peter Landin](https://upload.wikimedia.org/wikipedia/en/f/f9/Peter_Landin.png)

> Whatever the next 700 languages
> turn out to be,
> they will surely be
> variants of lambda calculus.

Peter Landin, 1966

## Syntax: What Programs _Look Like_

**Three** kinds of expressions

- `e`

**Variables**

- `x`, `y`, `z`

**Function Definitions (Abstraction)**

- `\x -> e`

**Function Call (Application)**

- `e1 e2`

**Complete Description**

![The Lambda Calculus](/static/img/lambda-calculus.png)

## Syntax: Association

## Application Is Left Associative

We write

`e1 e2 e3 e4`

instead of

`(((e1 e2) e3) e4)`

## Examples

```haskell
\x -> x             -- The Identity function

\y -> \x -> x       -- A function that returns the Identity Fun

\f -> f (\x -> x)   -- A function that applies arg to the Identity Fun
```

## Semantics : What Programs _Mean_

We define the _meaning_ of a program with simple rules.

1. Scope
2. $\alpha$-step  (aka. _renaming formals_)
3. $\beta$-step   (aka. _function calls_)


## Semantics: Scope

The part of a program where a **variable is visible**

In the expression `\x -> e`

- `x` is the newly introduced variable

- `e` is **the scope** of `x`

- `x` is **bound** inside `e`

## Semantics: Free vs Bound Variables

`y` is **free** inside `e` if

- `y` appears inside `e`, and
- `y` is **not bound** inside `e`

Formally,

```haskell
free(x)       = {x}
free(\x -> e) = free(e)  - {x}
free(e1 e2)   = free(e1) + free(e2)
```

## QUIZ

Let `e` be the expression `\x -> x (\y -> x y z)`.

Which variables are *free* in `e` ?

**A.**  `x`

**B.**  `y`

**C.**  `z`

**D.**  `x`, `y`

**E.**  `x`, `y`, `z`


## Semantics: $\alpha$-Equivalence

$\lambda$-terms `E1` and `E2` are $\alpha$-equivalent if

- `E2` can be obtained be *renaming the bound variables* of `E1`

or

- `E1` can be obtained be *renaming the bound variables* of `E2`

## Semantics: $\alpha$-step

**Example:** The following three terms are $\alpha$-equivalent

```haskell
\x -> x   =a> \y -> y   =a> \z -> z
```

We write `E1 =a> E2` if `E1` is $\alpha$-equivalent to `E2`.  

- We can say `E1` takes an $\alpha$-step to `E2`.

## $\alpha$-step Makes Scope Clear

We often $\alpha$-rename to make **parameter names unique**

For example, instead of

```haskell
    \x -> x (\x -> x) x     -- Yucky scope

=a> \x -> x (\y -> y) x     -- Scope of bindings crystal clear
```


## Semantics: Function Calls

In the $\lambda$-calculus, a "function call" (application) looks like `(x -> E1) E2`


| **Function** | **Argument**  |
|:------------:|:-------------:|
| `\x -> E1`   | `E2`          |


How do we **evaluate** the _function_ with the given _argument_?

1. **Rename** parameters to make them unique
2. **Substitute** all occurrences of `x` in `E1` with `E2`!

If so, we say that

- `(\x -> E1) E2` $\beta$-steps to `E1[x := E2]`

and we can write it as

- `(\x -> E1) E2   =b>   E1[x := E2]`


## Function Calls: $\beta$-step Example

Replace occurrences of parameter `f` with argument

```haskell
(\f -> f (f x)) g        

   =b>     g (g x)
```

No need to rename, bindings already unique

## Normal Forms

An **redex** is a $\lambda$-term of the form

`(\x -> E1) E2`

A $\lambda$-term is in **normal form** if it contains no redexes.

## QUIZ

Is the term `x` in _normal form_ ?

**A.** Yes

**B.** No


## QUIZ

Is the term `x y` in _normal form_ ?

**A.** Yes

**B.** No


## QUIZ

Is the term `(\x -> x) y` in _normal form_ ?

**A.** Yes

**B.** No



## QUIZ

Is the term `x (\y -> y)` in _normal form_ ?

**A.** Yes

**B.** No



## Semantics: Evaluation

A $\lambda$-term `E` **reduces/evaluates to a normal form** `E'` if

there is a sequence of steps

```haskell
E =?> E_1 =?> ... =?> EN =?> E'
```

where each `=?>` is

- An $\alpha$-step `=a>` or
- A  $\beta$-step `=b>`.


## Examples of Evaluation

```haskell
(\x -> x) E
  =b> E
```

```haskell
(\f -> f (\x -> x)) (\x -> x)
  =a> (\f -> f (\x -> x)) (\y -> y)
  =b> (\y -> y) (\x -> x)
  =b> (\x -> x)
```

## Non-Terminating Evaluation

```haskell
(\x -> x x) (\y -> y y)
  =b> (\y -> y y) (\y -> y y)
  =a> (\x -> x x) (\y -> y y)
```

Oops, we can write programs that loop back to themselves...

- Self replicating code!

## $\lambda$-Calculus Review

**Super tiny language**

- `E ::= x | \x -> E | (E E)`

**Many [evaluation strategies](http://dl.acm.org/citation.cfm?id=860276)**

- Many steps possible, which to take?
- Call-by-name
- Call-by-value
- Call-by need

**Church Rosser Theorem**

- Regardless of strategy at most *one normal form*
- i.e. Programs can evaluate to a single result.

## $\lambda$-calculus and CSE 130?


> Whatever the next 700 languages
> turn out to be,
> they will surely be
> variants of lambda calculus.

Huh? What was that Landin fellow going on about?

## Programming with the $\lambda$-calculus

*Real languages have lots of features*

- Booleans
- Branches
- Records
- Numbers
- Arithmetic
- Functions (ok, we got those)
- Recursion

Lets see how to _encode_ all of the above
with the $\lambda$-calculus.

**Hidden Motive**

- Free your mind
- Build intuition about **evaluation-by-substitution**

## QUIZ

```haskell
let bar = \x y -> x
```

What does `(bar apple orange)` evaluate to?

**A.**  `bar orange`

**B.**  `bar apple`

**C.**  `apple`

**D.**  `orange`

**E.**  `bar`

## $\lambda$-calculus: Booleans

**What can we _do_ with a Boolean?**
- Make a _binary choice_

**How can we encode _choice_ as a function?**
- A Boolean is a function that
- Takes _two_ inputs
- Returns _one of_ them as output

**True and False**

```haskell
let TRUE  = \x y -> x       -- returns FIRST  input
let FALSE = \x y -> y       -- returns SECOND input
```

Here, `let NAME = e` means `NAME` is an _abbreviation_ for `e`

- We don't want to keep _re-typing_ the whole expression out.


## QUIZ

Given

```haskell
let TRUE  = \x y -> x
let FALSE = \x y -> y
```

What does `(TRUE apple orange)` evaluate to?

**A.**  `apple`

**B.**  `orange`

**C.**  None of the above


## $\lambda$-calculus: Branches

A **branch** is a function that takes _three_ inputs

```haskell
let ITE = \b x y -> ...
```

- If `b` evaluates to `TRUE`  return `x`
- If `b` evaluates to `FALSE` return `y`

In other languages like C or JavaScript you would write

```javascript
 b ? x : y
```

How shall we implement `ITE` as a $\lambda$-expression?

```haskell
let ITE   = \b x y -> b x y
```

## Example: Branches

We want

- `if TRUE  then e1 else e2` to evaluate to `e1`

Does it?

```haskell
eval ite_true:
  ITE TRUE e1 e2
  =d> (\b x y -> b    x  y) TRUE e1 e2    -- expand def ITE  
  =b>   (\x y -> TRUE x  y)      e1 e2    -- beta-step
  =b>     (\y -> TRUE e1 y)         e2    -- beta-step
  =b>            TRUE e1 e2               -- expand def TRUE
  =d>     (\x y -> x) e1 e2               -- beta-step
  =b>       (\y -> e1)   e2               -- beta-step
  =b> e1
```

## Example: Branches

Now you try it! We want

- `if FALSE then e1 else e2` to evaluate to `e2`

Can you [fill in the blanks to make it happen?][elsa-ite]


```haskell
eval ite_false:
  ITE FALSE e1 e2

  -- fill the steps in!

  =*> e2  
```

## QUIZ

```
let TRUE  = \p q   -> p
let FALSE = \p q   -> q
let HAHA  = \b x y -> ITE b FALSE TRUE
```

What does `HAHA TRUE` evaluate to?

**A.** `HAHA TRUE`

**B.** `TRUE`

**C.** `FALSE`

**D.** `HAHA`

**E.** `HAHA FALSE`


## Boolean Operators: NOT


We can develop the Boolean operators from **truth tables**

| `b`   | `NOT b` |
|:-----:|:-------:|
| TRUE  | FALSE   |
| FALSE | TRUE    |

We can encode the above as:

```haskell
let NOT = \b -> ITE b FALSE TRUE
```

That is, `HAHA` is actually the [`NOT` operator!][elsa-not]


## Boolean Operators: AND

Similarly, `AND b1 b2` is defined by the truth table

| `b1`   | `b2`   |  `AND b1 b2` |
|:-----:|:-------:|:------------:|
| FALSE | FALSE   |  FALSE       |
| FALSE | TRUE    |  FALSE       |
| TRUE  | FALSE   |  FALSE       |
| TRUE  | TRUE    |  TRUE        |

We can encode the truth table as a function

```haskell
let AND = \b1 b2 -> ITE b1 (ITE b2 TRUE FALSE) FALSE
```

which can be simplified to

```haskell
let AND = \b1 b2 -> b1 b2 FALSE
```

(Can you see why?)


## Boolean Operators: OR

Similarly, `OR b1 b2` is defined by the truth table

| `b1`   | `b2`   |  `AND b1 b2` |
|:-----:|:-------:|:------------:|
| FALSE | FALSE   |  FALSE       |
| FALSE | TRUE    |  TRUE        |
| TRUE  | FALSE   |  TRUE        |
| TRUE  | TRUE    |  TRUE        |

We can encode the truth table as a function

```haskell
let OR = \b1 b2 -> ITE b1 TRUE (ITE b2 TRUE FALSE)
```

which can be simplified to

```haskell
let OR = \b1 b2 -> b1 TRUE b2
```

(Can you see why?)


## $\lambda$-calculus: Records

What can we *do* with **records** ?

1. **Pack two** items into a record.
2. **Get first** item.
3. **Get second** item.

## Records : API

```haskell
(PACK v1 v2)  -- makes a pair out of v1, v2 s.t.

(FST p)       -- returns the first element

(SND p)       -- returns the second element
```

such that

```haskell
FST (PACK v1 v2) = v1

SND (PACK v1 v2) = v2
```

## Records: Implementation

A **create** a record as a **function**

```haskell
let PACK = \v1 v2 -> (\b -> ITE b v1 v2)
```

- Is called with a Boolean `b`
- Returns *first* element if `b` is `TRUE`
- Returns *second* element if `b` is `FALSE`

We **access** a record by **calling** it with `TRUE` or `FALSE`

```haskell
let FST  = \p -> p TRUE   -- call w/ TRUE, get first value

let SND  = \p -> p FALSE  -- call w/ FALSE, get second value
```

## Exercise: Records with 3 values?

How can we implement a record that contains **three** values?

```haskell
let PACK3 = \v1 v2 v3 -> ???

let fst3  = \r -> ???

let snd3  = \r -> ???

let thd3  = \r -> ???
```

## HEREHEREHEREHEREHERE

## $\lambda$-calculus: Numbers

`n f s` means run `f` on `s` exactly `n` times

```haskell
-- | represent n as  \f x. f (f (f  ...   (f x)
--                         '--- n times ---'

1 = \f x. f x
2 = \f x. f (f x)
3 = \f x. f (f (f x))
4 = \f x. f (f (f (f x)))
```

## QUIZ: Church Numerals

TODO

Which of these is a valid encoding of `0` ?

```haskell
-- A
zero = \f x. x

-- B
zero = \f x. f

-- C
zero = \f x. f x

-- D
zero = \x. x

-- E
-- none of the above!
```

## $\lambda$-calculus: Arithmetic

TODO

Lets implement a small API for numbers:

```haskell
isZero n = ... -- return `true` if n is zero and `false` otherwise
```

```haskell
plus1 n  = \f x. ?  -- ? should call `f` on `x` one more time than `n` does
```

```haskell
plus n m  = \f x. ?  -- ? should call `f` on `x` exactly `n + m` times
```

```haskell
mult n m  = \f x. ?  -- ? should call `f` on `x` exactly `n * m` times
```


```haskell
isZero = \n. n (\b. false) true
plus1  = \n. (\f s. n f (f s))
plus   = \n1 n2. n1 plus1 n2
mult   = \n1 n2. n2 (plus n1) zero
```

## $\lambda$-calculus: Recursion

TODO

[elsa-ite]: http://goto.ucsd.edu:8095/index.html#?demo=ite.lc

[elsa-not]: http://goto.ucsd.edu:8095/index.html#?demo=permalink%2F1491005489_149.lc
