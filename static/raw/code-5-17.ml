
(*

let x     = 10
                              [ x := 10 ]
let foo y = x + y
                              [ foo := < fun1 > ; x := 10 ]

let quiz1  = foo 0
                              [ quiz1 := 10 ; foo := < fun1 > ; x := 10 ]
let x     = 55
                              [ x := 55; quiz1 := 10 ; foo := < fun1 > ; x := 10 ]
let fooCopy = foo
                              [ fooCopy := <fun1> ; x := 55; quiz1 := 10 ; foo := < fun1 > ; x := 10 ]

let foo y = x + y
                              [ foo := < fun2 > ; fooCopy := <fun1> ;x := 55; quiz1 := 10 ; foo := < fun1 > ; x := 10 ]

let quiz2  = foo 0
                              [ quiz2 := 55; foo := < fun2 > ; fooCopy := <fun1> ;x := 55; quiz1 := 10 ; foo := < fun1 > ; x := 10 ]

fooCopy 0

What is (quiz1, quiz2) ?

A. (10, 10)
B. (55, 55)
C. (55, 10)
D. (10, 55)

*)


let foo x = x + 1

let foo       = fun x -> x + 1

let bar x y z = x + 2*y + 3*z
let bar x y   = fun z -> x + 2*y + 3*z
let bar x     = fun y -> fun z -> x + 2*y + 3*z
let bar       = fun x -> fun y -> fun z -> x + 2*y + 3*z



let bar (x, y, z) = x + 2*y + 3*z

let bar a = match a with
              (x, y, z) -> x + 2*y + 3*z

let bar = fun a -> match a with
                    (x, y, z) -> x + 2*y + 3*z 


(* (x, y, z) = x + 2*y + 3*z  *)





let f = fun x -> 1;;

let f = fun x -> if x < 2 then 1 else (x * f (x-1));;

let f = fun x -> if x < 2 then 1 else (x * f (x-1));;

let res = f 5;;

f3 5
===> 5 * (f2 4)
===> 5 * (4 * (f1 3))
===> 5 * (4 * 1)
===> 20








(***********************************************************************)

type var  = string

type expr = Number of int
          | Mul    of expr * expr
          | Add    of expr * expr
          | Var    of var
          | Let    of var * expr * expr;;

        (*  let       "x" = e1   in e2  *)

type env = (var * int) list

(* val lookup : env -> var -> int *)
let rec lookup env x = match env with
  | []                 -> failwith ("Unbound variable: "^x)
  | (key, value)::rest -> if key = x then value else lookup rest x
  ;;

(* val eval : env -> expr -> int *)
let rec eval env e = match e with
  | Number n        -> n
  | Add (e1, e2)    -> eval env e1 + eval env e2
  | Mul (e1, e2)    -> eval env e1 * eval env e2
  | Var x           -> lookup env x
  | Let (x, e1, e2) -> let v1 = eval env e1        in
                       let newEnv = (x, v1) :: env in
                       eval newEnv e2
