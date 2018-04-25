---
title: Higher-Order Functions 
date: 2018-04-23
headerImg: books.jpg
---

# Plan 

- More on *recursion*

- *Tail* recursion

- Higher-order Functions
  - Functions taking and returning functions

- Some useful HOFs: `map`, `filter`, and `fold`


## Recursion

- A way of life

- A different way to view computation 
  
  - Solutions for _big_ problems
  
  - From solutions for _sub_-problems

## Why use Recursion?

1. Often far simpler, cleaner than loops 
  - But not always...

2. Forces you to factor code into reusable units 
  - Only way to "reuse" loop is via cut-paste

## QUIZ: What does `quiz` evaluate to ?

```haskell
foo :: Int -> Int -> [Int]
foo i j
  | i < j     = i : (foo (i+1) j)
  | otherwise = []

quiz = foo 0 3
```

**A.** `[0, 1, 2]`

**B.** `[0, 0, 0]` 

**C.** `[]`

**D.** `[2, 2, 2]`

**E.** `[2, 1, 0]`


## QUIZ: Lets see what `quiz` evaluates to

```haskell
range :: Int -> Int -> [Int]
range i j
  | i < j     = i : (range (i+1) j)
  | otherwise = []

quiz = range 0 3
```

- `range 3 3` ====> `[]`
- `range 2 3` ====> `2:(range 3 3)` ====> `2:[]`
- `range 1 3` ====> `1:(range 2 3)` ====> `1:2:[]`
- `range 0 3` ====> `0:(range 1 3)` ====> `0:1:2:[]`

## Tail Recursion

Recursion where **last** sub-expression is the recursive call

- i.e. no computations allowed on recursively returned value; 

- i.e. value returned by the recursive call == value returned by function

## QUIZ: Is `range` Tail Recursive? 

```haskell
range :: Int -> Int -> [Int]
range i j
  | i < j     = i : (range (i+1) j)
  | otherwise = []
```

**A.** Yes

**B.** No


## `range` is NOT Tail Recursive! 

Lets see how `range 0 3` is evaluated.

```haskell
range 0 3
  ==> 0 : (range 1 3)            -- recursively call `range 1 3`
  ==> 0 : (1 : (range 2 3)       --   recursively call `range 2 3`
  ==> 0 : (1 : (2 : (range 3 3)  --     recursively call `range 3 3`
  ==> 0 : (1 : (2 : [])          --     cons 2 to result 
  ==> 0 : (1 : [2])              --   cons 1 to result
  ==> 0 : [1, 2]                 -- cons 0 to result
  ==> [0, 1, 2]
``` 

## QUIZ: Is `fact` Tail Recursive? 

```haskell
fac :: Int -> Int
fac n
  | n <= 1    = 1
  | otherwise = n * fac (n - 1)
```

**A.** Yes

**B.** No

## Lets see how `fact` works 

Lets evaluate `fact 4` 

```haskell
fac 4
  ==> 4 * (fac 3)              -- recursively call `fact 3`
  ==> 4 * (3 * (fac 2))        --   recursively call `fact 2`
  ==> 4 * (3 * (2 * (fac 1)))  --     recursively call `fact 1`
  ==> 4 * (3 * (2 * 1))        --     multiply 2 to result 
  ==> 4 * (3 * 2)              --   multiply 3 to result
  ==> 4 * 6                    -- multiply 4 to result
  ==> 24
```


## Lets write a tail recursive factorial! 

(I) lecture 

```haskell
facTR :: Int -> Int
facTR n = ... 
```

(I) final 

```haskell
facTR :: Int -> Int
facTR n = loop 1 n
  where
    loop :: Int -> Int -> Int
    loop acc n
      | n <= 1    = acc
      | otherwise = loop (acc * n) (n - 1)
```

## Lets see how `facTR` runs


```haskell
facTR 4
  ==> loop 1  4     -- recursively call loop 1 4
  ==> loop 4  3     -- recursively call loop 4 3 
  ==> loop 12 2     -- recursively call loop 12 2
  ==> loop 24 1     -- recursively call loop 24 1
  ==> 24            -- return result 24! 
```

Each recursive call **directly** returns the result 

  - without further computation

  - **Tail Recursion!**

## Why care about Tail Recursion?

Because _compiler_ can transform it into a _fast loop_

```haskell
facTR n = loop 1 n
  where
    loop acc n
      | n <= 1    = acc
      | otherwise = loop (acc * n) (n - 1)
```

```javascript 
function facTR(n){ 
  var acc = 1;
  while (true) {
    if (n <= 1) { return acc ; }
    else        { acc = acc * n; n = n - 1; }
  }
}
```

-  Tail recursive calls can be optimized as a **jump** or **loop**

- Part of the language specification 
  - ie: compiler **guarantees** to optimize tail calls

## Lets make `range` Tail Recursive!

```haskell
range :: Int -> Int -> [Int]
range i j
  | i < j     = i : (range (i+1) j)
  | otherwise = []
```

(I) lecture 

```haskell
rangeTR :: Int -> Int -> [Int]
rangeTR i j = ...
```

(I) final 

```haskell
rangeTR :: Int -> Int -> [Int]
rangeTR i j = loop [] i j
  where
    loop acc i j
      | i < j     = rangeTR (i:acc) (loop (i+1) j)
      | otherwise = acc
```

Lets run it and see what happens!

```haskell
range 0 3
  ==> loop []      0 3
  ==> loop [0]     1 3
  ==> loop [1,0]   2 3
  ==> loop [2,1,0] 3 3
  ==> [2,1,0]
```

Can you think of how to make list in increasing order?

## Recursion is good... 

- More practice with recursion 
  - Base pattern -> Base Expression 
  - Induction pattern -> Induction Expression 

## ... Higher-Order Functions are Better

Why have functions take/return functions? 

## Lets write: `evens`

```haskell
-- >>> evens []        == []
-- >>> evens [1,2,3,4] == [2,4]
```

(I) lecture 

```haskell
evens       :: [Int] -> [Int]
evens []     = ... 
evens (x:xs) = ...
```

(I) final 

```haskell
evens       :: [Int] -> [Int]
evens []         = []
evens (x:xs)
  | x mod 2 == 0 = x : evens xs
  | otherwise    =     evens xs
```

## Lets write: `fourLetters`

```haskell
-- >>> fourChars [] == []
-- >>> fourChars ["i","must","do","work"] == ["must","work"]
```

(I) lecture

```haskell
fourChars :: [String] -> [String]
fourChars []     = ... 
fourChars (x:xs) = ...
```

(I) final 

```haskell
fourChars :: [Int] -> [Int]
fourChars []      = []
fourChars (x:xs)
  | length x == 4 = x : fourChars xs
  | otherwise     =     fourChars xs
```

## Yikes, Most Code is the Same

Lets **rename** the functions to ... `foo` 

```haskell
foo :: [Int] -> [Int]
foo []            = []
foo (x:xs)
  | x mod 2 == 0  = x : foo xs
  | otherwise     =     foo xs

foo :: [Int] -> [Int]
foo []            = []
foo (x:xs)
  | length x == 4 = x : foo xs
  | otherwise     =     foo xs
```

Only difference is **condition**

- `x mod 2 == 0` vs `length x == 4`

## Moral of the day

**D.R.Y.** Don't Repeat Yourself!

## HOFs allow Factoring

General **Pattern** + Specific **Operation**

## The `filter` Pattern

![The Filter Pattern](/static/img/filter-pattern.png)

General Pattern 

- Recursively traverse list 

Specific Operations

- `isEven` and `isFour` 

![The Filter Instance](/static/img/filter-pattern-instance.png)

**Avoid duplicating code!**

## Lets write: `shout`

```haskell
-- >>> shout []                    == []
-- >>> shout ['h','e','l','l','o'] == ['H','E','L','L','O'] 
```

(I) lecture

```haskell
shout :: [Char] -> [Char]
shout []     = ...
shout (x:xs) = ... 
```

(I) final 

```haskell
shout :: [Char] -> [Char]
shout []     = [] 
shout (x:xs) = toUpper x : shout xs 
```

## Lets write: `listSquare`

```haskell
-- >>> squares []        == []
-- >>> squares [1,2,3,4] == [1,4,9,16] 
```

(I) lecture

```haskell
squares :: [Int] -> [Int]
squares []     = ...
squares (x:xs) = ... 
```

(I) final 

```haskell
squares :: [Int] -> [Int]
squares []     = []
squares (x:xs) = (x * x) : squares xs
```

## Oops, Most Code is the Same

Lets **rename** the functions to ... `foo` 

```haskell
-- shout
foo []     = []
foo (x:xs) = toUpper x : foo xs

-- squares
foo []     = []
foo (x:xs) = (x * x)   : foo xs
```

Lets **refactor** into the **common pattern**

(I) lecture

```haskell
pattern = ...
```

(I) final

```haskell
pattern f []     = []
pattern f (x:xs) = f x : pattern f xs
```

## The `map` Pattern

**Apply a transformation `f` to each element of a list**

```haskell
map f []     = []
map f (x:xs) = f x : map f xs
```

## Lets refactor `shout` and `squares`

(I) lecture

```haskell
shout   = map ...
squares = map ...
```

(I) final

```haskell
shout   = map (\x -> toUpper x)
squares = map (\x -> x * x    )
```

**Moral** Don't repeat yourself! 


## Fold