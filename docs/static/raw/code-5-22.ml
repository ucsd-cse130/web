
(* [] *)

let f = fun g ->
  let x = 0 in
  g 2

(* [ f :=> <fun1> ] *)

let x = 100

(* [ x :=> 100; f :=> <fun1> ] *)

let h = fun y -> x + y

(* [ h :=> <fun2>; x :=> 100; f :=> <fun1> ] *)

let res = f h

(*
  eval [ x :=> 0; g :=> <fun2> ]
       g 2

  eval [ y :=> 2, x :=> 100; f :=> <fun1> ]
       x + y

  ===> 102

  *)

(*
<fun1> = { formal = "g"
       , body   = "let x = 0 in g 2"
       , env    = []
       }

<fun2> = { formal = "y",
           body   = "x + y"
         , env    = [ x :=> 100; f :=> <fun1> ]
       }
*)






(* [] *)
let x   = 1;;
(* [x :=> 1] *)
let y   = 10;;
(* [y :=> 10; x :=> 1] *)
let f y = x + y;;
(* [f :=> <fun>; y :=> 10; x :=> 1] *)
let x   = 2;;
(* [ x :=> 2; f :=> <fun>; y :=> 10; x :=> 1] *)
let y   = 3;;
(* [ y := 3; x :=> 2; f :=> <fun>; y :=> 10; x :=> 1] *)
let res = f (x + y);;

           (* eval [y :=> 5; y :=> 10; x :=> 1] (x + y) *)

(* <fun> = { formal = "y"
           , body   = "x + y"
           , env    = [y :=> 10; x :=> 1]
           }
 *)

(* [] *)
let x = 1;;

(* [ x :=> 1 ] *)

let f y = let x = 2 in
          fun z -> x + y + z;;

(* [ f :=> <fun1> ; x :=> 1 ] *)

let x = 100;;

(* [ x :=> 100; f :=> <fun1> ; x :=> 1 ] *)

let g = f 4 ;; (* a function that adds 6 to its input *)

(* [ g :=> <fun2>, x :=> 100; f :=> <fun1> ; x :=> 1 ] *)

let y = 100;;

(* [ y :=> 100; g :=> <fun2>, x :=> 100; f :=> <fun1> ; x :=> 1 ] *)

let res = g 1 ;;  (* should get 6 + 1 == 7 *)

(*
  eval [ z :=> 1; x :=> 2; y :=> 4; x :=> 1 ]
       (x + y + z)

 ===> 7

*)

(* <fun1> = { formal = "y"
            , body   = "let x = 2 in
                        fun z -> x + y + z"
            , env    = [ x :=> 1 ]
            }

   <fun2> = { formal = "z"
            , body   = "x + y + z"
            , env    =  [ x :=> 2; y :=> 4; x :=> 1 ]
            }
 *)



(*
                            []
let foo  = fun f -> f 0
                            [ foo :=> <fun1> ]
let incr = fun x -> x + 1
                            [ incr :=> <fun2> , foo := <fun1> ]
let ans  = foo incr
                            <"f", "f 0", []> = eval env foo
                            val    = eval env incr
                            newEnv = [("f", <fun2>)]
                            eval newEnv (f 0)

    fun1 = { param  = "f"
           , code   = "(f 0)"
           , env    = []
           }

    fun2 = { param  = "x"
           , code   = "(x + 1)"
           , env    = [ foo :=> <fun1> ]
           }

*)

let a = 20

let rec factorial x = if x < 1 then 1 else x * (factorial (x - 1))

let f x =
  let y = 1       in
  let g z = y + z in
    a + (g x)

let simple = fun z -> z + 1 in
  10 + simple 20

let simple = 12 in
  simple + simple





                          (* [] *)
let x = 2 + 2 ;;
                          (* [ x :=> 4] *)

let y = "cat";;
                          (* [ y :=> "cat"; x :=> 4] *)

let f = fun y -> x + y ;;
                          (* [ f :=> <fun1>; x :=> 4]
                            where <fun1> =
                               { input = "y"
                               , body  = "x + y"
                               , env   = [ y :=> "cat"; x :=> 4]
                               }
                          *)

let _ = f 5000 ;;

    closEnv = [ y :=> "cat"; x :=> 4]
    newEnv  = [ y :=> 5000 ; y :=> "cat"; x :=> 4]
    eval newEnv (Add (Var x) (Var y))

let x = x + x ;;         (* [ x :=> 8; f :=> <fun>; x :=> 4]  *)







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

  | App (e1, e2)    -> let <param, body, frozenEnv> = eval env e1 in
                       let argVal  = eval env e2 in

                          eval newEnv body

                          < "x", "x + x", [] >
                          argVal = 100

                              eval [(x :=> 100)] (Plus (Var x, Var x))

                            1. "apply-the-argVal-to-x"

                            newEnv = ((param, argVal) :: frozenEnv)

                       (* MAKE CALL HAPPEN! *)
