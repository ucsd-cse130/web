---
title: Lambda Calculus
headerImg: sea.jpg
---


<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## The Smallest Universal Language

![Alonzo Church](https://upload.wikimedia.org/wikipedia/en/a/a6/Alonzo_Church.jpg){#fig:church .align-center width=40%}

Developed in 1930s by Alonzo Church

- Studied in logic and computer science

Test bed for procedural and functional PLs

- Simple, Powerful, Extensible


<br>
<br>
<br>
<br>
<br>
<br>

## The Next 700 Languages

![Peter Landin](https://upload.wikimedia.org/wikipedia/en/f/f9/Peter_Landin.png){#fig:landin .align-center width=40%}

> Whatever the next 700 languages
> turn out to be,
> they will surely be
> variants of lambda calculus.

Peter Landin, 1966


<br>
<br>
<br>
<br>
<br>
<br>

## Syntax: What Programs _Look Like_

```javascript
e ::= x, y, z, ...
    | function(x){ return e }
    | e1(e2)

```

**Three** kinds of expressions

- `e`

**Variables**

- `x`, `y`, `z`    (in JS `x`, `y`, `z`)

**Function Definitions (Abstraction)**

- `\x -> e`        (in JS `function(x){return e}` or `(x) => e`)

**Function Call (Application)**

- `e1 e2`          (in JS `e1(e2)`)



**Complete Description**

![The Lambda Calculus](/static/img/lambda-calculus.png)


<br>
<br>
<br>
<br>
<br>
<br>



## Application Is Left Associative

We write

`e1 e2 e3 e4`

instead of

`(((e1 e2) e3) e4)`

We write

`\x1 -> \x2 -> \x3 -> \x4 -> e`

instead of

`\x1 -> (\x2 -> (\x3 -> (\x4 -> e)))`


<br>
<br>
<br>
<br>
<br>
<br>

## Examples

```haskell
\x -> x             -- The Identity function
                    -- function (x) { return x ;}
                    -- (x) => x

\y -> (\x -> x)     -- A function that returns the Identity Fun
                    --   function(y){ return
                    --      function (x) { return x ;}
                    --   }

\f -> f (\x -> x)   -- A function that applies arg to the Identity Fun
```


<br>
<br>
<br>
<br>
<br>
<br>

## Semantics : What Programs _Mean_

We define the _meaning_ of a program with simple rules.

1. Scope
2. $\alpha$-step  (aka. _renaming formals_)
3. $\beta$-step   (aka. _function calls_)



<br>
<br>
<br>
<br>
<br>
<br>

## Semantics: Scope

The part of a program where a **variable is visible**

In the expression `\x -> e`

- `x` is the newly introduced variable

- `e` is **the scope** of `x`

- `x` is **bound** inside `e`


```
  (\x -> (\y -> x)) x
```



<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ

Let `e` be the expression `\x -> x (\y -> x y z)`.

Which variables are *free* in `e` ?

**A.**  `x`

**B.**  `y`

**C.**  `z`

**D.**  `x`, `y`

**E.**  `x`, `y`, `z`


<br>
<br>
<br>
<br>
<br>
<br>


## Semantics: $\alpha$-Equivalence

$\lambda$-terms `E1` and `E2` are $\alpha$-equivalent if

- `E2` can be obtained be *renaming the bound variables* of `E1`

or

- `E1` can be obtained be *renaming the bound variables* of `E2`


<br>
<br>
<br>
<br>
<br>
<br>

## Semantics: $\alpha$-step

**Example:** The following three terms are $\alpha$-equivalent

```haskell
\x -> x   =a> \y -> y   =a> \z -> z
```

We write `E1 =a> E2` if `E1` is $\alpha$-equivalent to `E2`.  

- We can say `E1` takes an $\alpha$-step to `E2`.


<br>
<br>
<br>
<br>
<br>
<br>

## $\alpha$-step Makes Scope Clear

We often $\alpha$-rename to make **parameter names unique**

For example, instead of

```haskell
    \x -> x (\x -> x) x     -- Yucky scope

=a> \x -> x (\y -> y) x     -- Scope of bindings crystal clear
```


<br>
<br>
<br>
<br>
<br>
<br>


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



<br>
<br>
<br>
<br>
<br>
<br>

## Function Calls: $\beta$-step Example

Replace occurrences of parameter `f` with argument

```haskell
(\f -> f (f x)) g        

   =b>     g (g x)
```

No need to rename, bindings already unique


<br>
<br>
<br>
<br>
<br>
<br>

## Normal Forms

An **redex** is a $\lambda$-term of the form

`(\x -> E1) E2`

A $\lambda$-term is in **normal form** if it contains no redexes.


<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ

Is the term `x` in _normal form_ ?

**A.** Yes

**B.** No



<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ

Is the term `(x y)` in _normal form_ ?

**A.** Yes

**B.** No


<br>
<br>
<br>
<br>
<br>
<br>


## QUIZ

Is the term `(\x -> x) y` in _normal form_ ?

**A.** Yes

**B.** No



<br>
<br>
<br>
<br>
<br>
<br>


## QUIZ

Is the term `x (\y -> y)` in _normal form_ ?

**A.** Yes

**B.** No



<br>
<br>
<br>
<br>
<br>
<br>


## Semantics: Evaluation

A $\lambda$-term `E` **reduces/evaluates to a normal form** `E'` if

there is a sequence of steps

```haskell
E =?> E_1 =?> ... =?> EN =?> E'
```

where each `=?>` is

- An $\alpha$-step `=a>` or
- A  $\beta$-step `=b>`.


<br>
<br>
<br>
<br>
<br>
<br>


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


<br>
<br>
<br>
<br>
<br>
<br>

## Non-Terminating Evaluation

```haskell
(\x -> x x) (\y -> y y)
  =b> (\y -> y y) (\y -> y y)
  =a> (\x -> x x) (\y -> y y)
```

Oops, we can write programs that loop back to themselves...

- Self replicating code!


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

## $\lambda$-calculus and CSE 130?


> Whatever the next 700 languages
> turn out to be,
> they will surely be
> variants of lambda calculus.

Huh? What was that Landin fellow going on about?


<br>
<br>
<br>
<br>
<br>
<br>

## Programming with the $\lambda$-calculus

*Real languages have lots of features*

- Booleans *done*
- Branches *done*
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


<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ

```haskell
let bar = (\x y -> x)
```

What does `(bar apple orange)` evaluate to?

**A.**  `bar orange`

**B.**  `bar apple`

**C.**  `apple`

**D.**  `orange`

**E.**  `bar`


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>


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



<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ

```
let TRUE  = \p q -> p
let FALSE = \p q -> q
let HAHA  = \b   -> ITE b FALSE TRUE
```

What does `HAHA TRUE` evaluate to?

**A.** `HAHA TRUE`
**B.** `TRUE`
**C.** `FALSE`
**D.** `HAHA`
**E.** `HAHA FALSE`


<br>
<br>
<br>
<br>
<br>
<br>


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


<br>
<br>
<br>
<br>
<br>
<br>


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


<br>
<br>
<br>
<br>
<br>
<br>


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



<br>
<br>
<br>
<br>
<br>
<br>

## $\lambda$-calculus: Records

What can we *do* with **records** ?

1. **Pack two** items into a record.
2. **Get first** item.
3. **Get second** item.


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

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


<br>
<br>
<br>
<br>
<br>
<br>

## Exercise: Records with 3 values?

How can we implement a record that contains **three** values?

```haskell
let PACK3 = \v1 v2 v3 -> ???

let fst3  = \r -> ???

let snd3  = \r -> ???

let thd3  = \r -> ???
```


<br>
<br>
<br>
<br>
<br>
<br>

## $\lambda$-calculus: Numbers

`n f s` means run `f` on `s` exactly `n` times

```haskell
-- | represent n as  \f x. f (f (f  ...   (f x)
--                         '--- n times ---'

let ONE   = \f x. f x
let TWO   = \f x. f (f x)
let THREE = \f x. f (f (f x))
let FOUR  = \f x. f (f (f (f x)))
```


<br>
<br>
<br>
<br>
<br>
<br>

## QUIZ: Church Numerals

TODO

Which of these is a valid encoding of `ZERO` ?

```haskell
-- A
let ZERO = \f x. x

-- B
let ZERO = \f x. f

-- C
let ZERO = \f x. f x

-- D
let ZERO = \x. x

-- E
-- none of the above!
```


<br>
<br>
<br>
<br>
<br>
<br>

## $\lambda$-calculus: Arithmetic (`IsZero`)

Lets implement a small API for numbers:

```haskell
-- TRUE if n = ZERO and FALSE otherwise
let IsZero = \n -> ...
```

## $\lambda$-calculus: Arithmetic (`Incr`)

```haskell
-- Call `f` on `x` one more time than `n` does
let Incr   = \n -> (\f x -> ... )
```

An example!

```haskell
eval incr_one :
  Incr ONE
  =d> (\n f x -> f (n f x)) ONE
  =b> \f x -> f (ONE f x)
  =*> \f x -> f (f x)
  =d> TWO

eval incr_two :
  Incr TWO
  =d> (\n f x -> f (n f x)) TWO
  =b> \f x -> f (TWO f x)
  =*> \f x -> f (f (f x))
  =d> THREE
```

## QUIZ

How shall we implement `PLUS`?

```haskell
--  Call `f` on `x` exactly `n + m` times
let Plus = \n m -> ???  

eval plus_zero_zero :
  Plus ZERO ZERO =~> ZERO

eval plus_two_one :
  Plus TWO ONE =~> THREE

eval plus_two_two :
  Plus TWO TWO =~> FOUR
```

**A.**  `let Plus = \n m -> n Incr m`

**B.**  `let Plus = \n m -> Incr n m`

**C.**  `let Plus = \n m -> n m Incr`

**D.**  `let Plus = \n m -> n (m Incr)`

**E.**  `let Plus = \n m -> n (Incr m)`

$\lambda$-calculus: Arithmetic (`Plus`)


```haskell
--  Call `f` on `x` exactly `n + m` times
let Plus = \n m -> ???
```

An example!

```haskell
eval plus_zero_zero :
  Plus ZERO ZERO
  =~> ZERO

eval plus_two_two :
  Plus TWO TWO
  =~> FOUR
```

## QUIZ

How shall we implement `MULT`?

```haskell
--  Call `f` on `x` exactly `n + m` times
let Plus = \n m -> ???  

eval mult_zero_two :
  Mult ZERO TWO =~> ZERO

eval mult_two_one :
  Mult TWO ONE =~> TWO

eval mult_two_three :
  Mult TWO THREE =~> SIX
```

**A.**  `let Mult = \n m -> n Plus m`
**B.**  `let Mult = \n m -> n (Plus m) ZERO`
**C.**  `let Mult = \n m -> n (Plus m ZERO)`
**D.**  `let Mult = \n m -> (n Plus m) ZERO`
**E.**  `let Mult = \n m -> m (Plus n) ZERO`

## $\lambda$-calculus: Arithmetic (`Mult`)

```haskell
--  Call `f` on `x` exactly `n * m` times
let Mult = \n m -> ???

eval mul_two_three :
  mul two three
  =*> six
```


<br>
<br>
<br>
<br>
<br>
<br>

## $\lambda$-calculus: Recursion

The final frontier ...

[elsa-ite]: http://goto.ucsd.edu:8095/index.html#?demo=ite.lc

[elsa-not]: http://goto.ucsd.edu:8095/index.html#?demo=permalink%2F1491005489_149.lc
