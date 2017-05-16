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
  ;;

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
 1. "eval" e1 to get some value v1
      --> v1 is the value "bound" to x
 2. "eval" e2 in the environment where `x` is bound to v1

  *)

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

type environment = (var * int) list


(*
lookup [("x", 10); ("y", 20)] "x" = 10

lookup [("x", 10); ("y", 20)] "y" = 20

lookup [("x", 10); ("y", 20)] "z" = ??? (* THROWN EXCEPTION *)
*)

let rec lookup xvs x = failwith "HEREHEREHERE"
