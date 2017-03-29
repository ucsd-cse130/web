---
title: Lambda Calculus
---

Super brief notes, see details

Booleans
--------

```haskell
true  = \x y. x
false = \x y. y
ite   = \b x y. b x y
```

QUIZ
----

Given

```
foo = \b x y. b x y
bar = \p q. p
```

What does the following evaluate to?

```
foo bar apple orange
```

A. `foo bar apple orange`
B. `bar apple`
C. `apple`
D. `orange`
E. `bar`

QUIZ
----

Given

```
foo = \b x y. b x y
bar = \p q. p
baz = \b x y. b y x
```

What does the following evaluate to?

```
foo (baz bar) apple orange
```

A. `foo bar apple orange`
B. `bar apple`
C. `apple`
D. `orange`
E. `bar`


Boolean Operators
-----------------

We can develop the operators from their **truth tables**

```haskell
not = \b. ite b false true
and = \b1 b2. ite b1 b2 false
or  = \b1 b2. ite b1 true b2
```

Note that **for any** `a`, `b` and `c` we have:

```
ite a b c
  = (\b x y. b x y) a b c
  = a b c
```

hence we can simplify the above to

```haskell
not = \b.     b false true
and = \b1 b2. b1 b2 false
or  = \b1 b2. b1 true b2
```

Pairs
-----

What can we *do* with **pairs** ?

1. put **two** items into a pair.
2. get **first** item.
3. get **second** item.



Pairs : API
-----------

```haskell
(put v1 v2)  -- makes a pair out of v1, v2 s.t.

(getFst p)   -- returns the first element

(getSnd p)   -- returns the second element
```

such that

```haskell
getFst (put v1 v2) = v1
getSnd (put v1 v2) = v2
```

Pairs : Implementation
----------------------

```haskell
put v1 v2 = \b. ite b v1 v2

getFst p  = p true

getSnd p  = p false
```


QUIZ
----

Suppose we have

```haskell
one   = \f x. f x
two   = \f x. f (f x)
three = \f x. f (f (f x))
four  = \f x. f (f (f (f x)))
```

What is the value of

```
foo (mkPair true) false

foo (mkPair true) false =

mkPair 1 (mkPair 2 (mkPair 3 false))
```

A. `true`
B. `false`
C. `mkPair true false`
D. `mkPair true (mkPair true false)`
E. `mkPair true (mkPair true (mkPair true false))`


Naturals
--------

`n f s` means run `f` on `s` exactly `n` times

```haskell
-- | represent n as  \f x. f (f (f  ...   (f x)
--                         '--- n times ---'

1 = \f x. f x
2 = \f x. f (f x)
3 = \f x. f (f (f x))
4 = \f x. f (f (f (f x)))
```

QUIZ: Church Numerals
---------------------

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

sub1 n = getSnd (n (\(flag, res) -> if (flag) (true, res + 1) (true, res))  (false, 0))


function sub1(n){
 var res = (false, 0);


  var flag = false;
 for (var i=0; i<n; i++){
   if (flag)
     res += 1;
   else
     flag = true;
 }
 return res;
}



Operating on numbers
--------------------

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

Recursion
---------
