

(*
   e1 - e2 - e3

    LEFT  ASSOCIATIVE (e1 - e2) - e3
    RIGHT ASSOCIATIVE e1 - (e2 - e3)

  foo x1 x2 x3

      LEFT  ((((foo x1) x2) x3))
      RIGHT (foo (x1 (x2 x3)))

  x1 :: x2 :: x3 :: rest

      LEFT  (((x1 :: x2) :: x3) :: rest)
      RIGHT (x1 :: (x2 :: (x3 :: rest)))
 *)

(* PARAMETRIC Polymorphism  = "MANY TYPES" *)

(* function foo<A, B>((x:A, y:B)) : (B, A) = (y, x)

   JAVA / Scala etc.
      T1 extends T2 (T1 is a subclass of T2)
      foo(T2 x)
      can also be called with T1

     "SUBTYPE POLYMORPH"
   void foo(Shape s){ ... }

    foo(new Square());
    foo(new Circle());

 *)

let foo (x, y) = (y, x)

(* Which of these is a VALID type for foo?

 A. (int * int) -> (int * int)
 B. (int * bool) -> bool * int
 C. 'a -> 'a
 D. ('a * 'b) -> ('b * 'a)
 E. ('a * 'a) -> ('a * 'a)
 *)

type list = Nil | Cons of int    * list
type list = Nil | Cons of bool   * list
type list = Nil | Cons of string * list

type 'a list = Nil | Cons of 'a  * 'a list

let rec len xs = match xs with
  | Nil -> 0
  | Cons (_, xs) -> 1 + len xs

type expr =
  | Num of int
  | Div of expr * expr


let rec eval (e:expr) : (int * bool) = match e with
  | Num n -> n
  | Div (e1, e2) -> let n1 = (eval e1) in
                    let n2 = (eval e2) in
                      if n2 = 0 then (0, false) else (n1 / n2, true)

type 'a ornull = Null | Bob of 'a

let rec eval' (e:expr) : int ornull = match e with
  | Num n -> Some n
  | Div (e1, e2) -> let n1o = eval' e1 in
                    let n2o = eval' e2 in
                    match (n1o, n2o) with
                      | (_, Null) -> Null
                      | (Null,_)  -> Null
                      | (Some n1, Some n2) -> if n2 = 0
                                              then Null
                                              else Some (n1 / n2)
