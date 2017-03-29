---
title: Partial Solution Key For Sample Exams
headerImg: books.jpg
---

## Final Fall 06

### 6 (a)

~~~~~{.scala}
def elementAndRest[A](xs: List[A]): Iterator[(A, List[A])] = {
  for (i <- (0 until xs.length).iterator)
    yield (xs(i), xs.slice(0, i) ++ xs.slice(i+1, xs.length))
}
~~~~~

### 6 (b)

~~~~~{.scala}
def permutations[A](xs: List[A]): Iterator[List[A]] =
  xs match {
    case Nil     =>
      Iterator(List())
    case x::rest =>
      for ( ys <- permutations(rest)
          ; i  <- 0 until xs.length)
      yield ys.slice(0, i) ++ List(x) ++ ys.slice(i, ys.length)
  }
~~~~~

## Fall 07

### 6 (d)

~~~~~{.scala}
object tick {
  private var ctr = 0
  def apply() = {
    ctr += 1
    ctr
  }
}
~~~~~

### 7 (a)

~~~~~{.scala}
def valid(es:List[(Int, Int)], c: List[Int]): Boolean =
  es.forall(e => c(e._1) != c(e._2))
~~~~~


### 7 (b)

~~~~~{.scala}
def colorings(n: Int, k: Int): List[List[Int]] = {
  if (n <= 0) List(List())
  else { for ( cs <- colorings(n-1, k)
             ;  c <- 0 until k)
         yield (c::cs) }
}

~~~~~

### 7 (c)

~~~~~{.scala}
def initColoring(n: Int) =
  (0 until n).toList.map(x => 0)

def lastColoring(xs: List[Int], k: Int) =
  xs.forall(_ == k-1)

def nextColoring(xs: List[Int], k: Int) = {
  var res : List[Int] = List()
  var carry = 1
  for (i <- (xs.length - 1) to 0 by -1) {
    val sum = carry + xs(i)
    val dig = sum % k
    carry   = sum / k
    res     = dig :: res
  }
  res
}
~~~~~


## Midterm Spring 12

### 1 (a)

~~~~~{.ocaml}
val (<.>) : ('b -> 'c) -> ('a -> 'b) -> ('a -> 'c)
~~~~~

### 1 (b)

~~~~~{.ocaml}
10
~~~~~

### 1 (c)

~~~~~{.scala}
let giftList =
  let rec helper acc xs = match xs with
    | []     -> acc^" and thats what I want for Christmas!"
    | x::xs' -> helper (acc ^ " and ") xs'
  in helper ""
~~~~~

### 2 (a)

~~~~~{.ocaml}
val getEven : int list -> int option
~~~~~

### 2 (b)


~~~~~{.ocaml}
let rec find_first f xs = match xs with
  | []     -> None
  | x::xs' -> if f x then Some x else find_first f xs'
~~~~~

### 2 (c)

~~~~~{.ocaml}
val tree_to_string: string tree -> string
~~~~~

### 2 (d)

~~~~~{.ocaml}
let rec post_fold f b t = match t with
  | Leaf           -> b
  | Node (x, l, r) -> f x (post_fold f b l) (post_fold f b r)
~~~~~

### 2 (e)

~~~~~{.ocaml}
let rec in_fold f b t = match t with
  | Leaf           -> b
  | Node (x, l, r) -> let bl = in_fold f b l  in
                      let bx = f bl x         in
                      let br = in_fold f bx r in
                      br
~~~~~


### 3 (a)

~~~~~{.ocaml}
Left 3
~~~~~

### 3 (b)

~~~~~{.ocaml}
Right "monkey"
~~~~~


### 3 (c)

~~~~~{.ocaml}
let rec assoc key kvs = match kvs with
  | (k, v)::rest -> if key = k then Right v else assoc key rest
  | []           -> Left key
~~~~~

### 3 (d)

~~~~~{.ocaml}
let map f e = match e with
  | Left l -> Left l
  | Right r -> Right (f r)
~~~~~

### 3 (e)

~~~~~{.ocaml}
let map2 f e1 e2 = match (e1, e2) with
  | Right r1, Right r2 -> Right (f r1 r2)
  | Left l, _  -> Left l
  | _, Left l  -> Left l
~~~~~


### 4 (a)

~~~~~{.ocaml}
let lookup x env = match assoc x env with
  | Left z  -> Left (UnboundVariable z)
  | Right i -> Right i
~~~~~

### 4 (b)

~~~~~{.ocaml}
let safeDiv n m =
  if m != 0 then Right (n / m) else Left DivideByZero
~~~~~

### 4 (c)

~~~~~{.ocaml}
let rec eval env e = match e with
  | Const i            -> Right i
  | Var v              -> lookup v env
  | Bin (e1, Plus, e2) -> map2 (+) (eval env e1) (eval env e2)
  | Bin (e1, Div, e2)  -> (match (eval env e1) (eval env e2) with
                           | _, Right 0 -> Left DivideByZero
                           | Right i1, Right i2 -> Right (i1/ i2)
                           | Left l, _ | _, Left l -> Left l)
~~~~~
