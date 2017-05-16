(***********************************************************************)

type var  = string

type expr = Number of int
          | Mul    of expr * expr
          | Add    of expr * expr
          | Var    of var
          | Let    of var * expr * expr;;

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
  | Let (x, e1, e2) -> let v1     = eval env e1     in
                       let newEnv = env @ [(x, v1)] in
                       eval newEnv e2
  ;;
(*
eval [] (Let "x", Number 7, e2)
==> eval [("x", 7)] (Let "y", Number 12, Add (Var "y", Var "x"))
==> eval [("y", 12)]  (Add (Var "y", Var "x"))
*)

let test6 = (Let ("x", Number 7,
              Let ("x", Number 12,
                Add (Var "x", Var "x")))) ;;
(*
eval [] (Let "x", Number 7, e2)
==> eval [("x", 7)] (Let ("x", Number 12, Add (Var "x", Var "x")))
==> eval ([("x", 7); ("x", 12)])  (Add (Var "x", Var "x"))
==> (eval ... Var "x") + (eval ... Var "x")
==> (lookup ... "x") + (lookup ... "x")
==> 7 + 7
==> 14
*)

(*
let test7 =
  let x = 7 in
    let x = 12 in
      x + x

WHAT IS THE VALUE OF test7 ?

A. Type Error
B. 19
C. 24
D. 14
E. Exception "Unbound Variable" ...
*)


(* How should we implement ???

B. (x, v1) :: env

E. env @ [(x, v1)]

*)


(* eval env (Let x = e1 in e2)

   1. "eval env e1" to get some value v1
        --> v1 is the value "bound" to x
   2. "eval" e2 in the environment where `x` is bound to v1

*)




(*
eval [] (Let "x", Number 10, Var "x")
===> eval [("x", 10)] (Var "x")
===> 10

eval [] (Let "cat", Number 10,
           (Let "dog", Number 20,
              Add (Var "cat", Var "dog")
           )
        )
eval [("cat", 10)] (Let "dog", Number 20,
                     Add (Var "cat", Var "dog")
                   )

eval [("dog", 20);("cat", 10)] (Add (Var "cat", Var "dog"))

eval [("dog", 20);("cat", 10)] (Var "cat")
    +
eval [("dog", 20);("cat", 10)] (Var "dog")

10 + 20

30
*)


(*
let test3 =
  Let ("x", Number 10
    , Mul ( Let ("y", Number 20, Add (Var "x", Var "y"))
          , Let ("y", Number 5 , Add (Var "x", Var "y"))
          )
    )
;;

eval [] test3

A. 450
B. 900
C. Unbound Var

let x = 10 in
  (let y = 20 in x + y ) * (let y = 5  in x + y )

A. 45
B. 90
C. 900
D. 450
E. DeATH (unbound var)


let _ = eval x (Var "x") ;;
let _ = eval [("x", 1000)] (Var "x") ;;
let _ = eval [("y", 5); ("x", 1000)] (Var "x") ;;
let _ = eval [("y", 5); ("z", 1000)] (Var "x");;


let test1 = Let ("x", Number 10, Var "x");;

eval [] test1

A. 10
B. Type error
C. unbound var
*)

(*
  let x = 10 in
    let y = x + x  in
      (2 + x)
      +
      (5 * y)
*)

let test2 = Let ("x", Number 10,
          Let ("y", Add (Var "x", Var "x")  ,
            Add ( Add (Number 2 , Var "x")
                , Mul (Number 5 , Var "y")
                )
          )
         )
let x = 2+2        in       (* [(x, 4)]*)
let y = x * x * x  in       (* [(y,64); (x, 4)] *)
let z = [x;y;x+y]  in       (* [(z,[4,64,68]); (y,64); (x,4)] *)                 *)
let x = x + x      in       (* [(x,8); (z,[4,64,68]); (y,64); (x,4)] *)
...












let x     = 2 + 2 ;;
                          [ x => 4 ]

let foo y = x + y ;;

foo 0 ==> 4


                          [ foo => < FUN> ; x => 4]

let x     = 1000 ;;
                          [ x => 1000; foo => <CLOSURE> ; x => 4]

let ans = foo 0 ;;

foo 0 ==> 1004




A.  1000
B.  1004
C.  2000
D.  4
E.  4





let x = 10 in
   ( let x = 500 in x + x )
   +
   x

A. 1000
B. 1010
C. 1500
D. 1510
E. FLAME AND BURN
