
(* DataTypes *)


type attrib =
  | Name    of string
  | Age     of int
  | DOB     of int * int * int
  | Address of string
  | Height  of float 
  | Alive   of bool
  | Email   of string
  | Null
;;

let a1 = Name "Bob";;

let a2 = Height 5.83;;

let year = 1977 ;;

let a3 = DOB (9,8,year) ;;

let a_l = [a1;a2;a3];;











let a1 = (Alive false);;
let a1 = (Name "Bob");;
let a1 = (Age 11);;
match a1 with
| Name s -> 0
| Age i -> i
| _ -> 10;;




match (Name "Hi") with
| Name s -> (Printf.printf "Hello %s\n" s;0)
| Age i  -> (Printf.printf "%d years old\n" i;0)
| _ -> (Printf.printf "\n"; 0)
;;



























match (Age 10) with
  | Age i when i < 10 -> Printf.sprintf "%d (young)" i
  | Age i -> Printf.sprintf "%d (older)" i
  | Email s -> Printf.sprintf "%s" s
  | _ -> ""
;;                


let to_str a = 
  match a with 
  | Name s -> s
  | Age i -> Printf.sprintf "%d" i
  | DOB (d,m,y) -> Printf.sprintf "%d / %d / %d" d m y 
  | Address addr -> Printf.sprintf "%s" addr
  | Height h -> Printf.sprintf "%f" h 
  | Alive b -> Printf.sprintf "%b" b
  | Email e -> Printf.sprintf "%s" e
;;

type attrib =
  | Name    of string
  | Age     of int
  | DOB     of int * int * int
  | Address of string
  | Height  of float 
  | Alive   of bool
  | Email   of string
;;








(* internally, the bool type is as follows: *)
(* type bool = true | false;; *)

(* but we don't type this into ocaml, otherwise it will shadow
internal bool type! *)

(* how can we write the following using match? *)
if cond then e1 else e2











type bool = 
        | True
        | False;;





match 4 < 50 with
| true -> "yes"
| false -> "no" ;;

let foo i = match i with
  | 0 -> "zero"
  | 1 -> "one"
  | _ when i < 10 -> "less than 10"
  | _             -> "BIGGER THAN 10";; 


(* Redundancy and completeness checks *)

let to_str a = 
  match a with 
  | Name s -> Printf.sprintf "%s" s
  | Age i -> Printf.sprintf "%d" i
  | DOB (d,m,y) -> Printf.sprintf "%d / %d / %d" d m y 
  | Address addr -> Printf.sprintf "%s" addr
  | Height h -> Printf.sprintf "%f" h 
  | Alive b -> Printf.sprintf "%b" b
  | Email e -> Printf.sprintf "%s" e
  | Name s -> Printf.sprintf "%s" s
;;

let to_str a = 
  match a with 
  | Name s -> Printf.sprintf "%s" s
  | Age i -> Printf.sprintf "%d" i
  | DOB (d,m,y) -> Printf.sprintf "%d / %d / %d" d m y 
  | Address addr -> Printf.sprintf "%s" addr
  | Height h -> Printf.sprintf "%f" h 
  | Alive b -> Printf.sprintf "%b" b
;;

(* go back to slides *)



type mylist =
        | Nil
        | NonEmpty of (int * mylist);;

type nat = 
  | Z 
  | S of nat;;














Z;; (* represents 0 *)
S Z;; (* represents 1 *)
S S Z;; (* represents 2 *)
S (S Z);; (* represents 2 *)









(* write to_int: takes a nat represented as above
   and returns the int value of that nat *)

let rec to_int n = 
    match n with
    | Z -> 0
    | S i -> 1 + (to_int i);;
     
to_int S (S (S (S Z)))  i = (S (S (S Z))
1 + (to_int (S (S (S Z))))
1 + (1 + (to_int (S (S Z))))
1 + (1 + (1 + (to_int (S Z))))
1 + (1 + (1 + (1 + to_int Z)))















































let rec to_int n = 
  match n with
    | Z -> 0
    | S n' -> 1 + (to_int n');;

to_int S Z;;
to_int (S Z);;
to_int (S (S Z));;

(* write to_nat: takes an int >=0 and returns
   a nat resprenting that integer *)

let rec to_nat i =
   match i with
   | _ when i>0 -> S (to_nat (i-1))
   | _ -> Z

to_nat 2
S (to_nat 1)
S (S (to_nat 0))
S (S Z)




















let rec to_nat i = 
   if i <= 0 then Z
   else S (to_nat (i - 1));;

let rec to_nat i = 
  match i with 
    | i when i <= 0 -> Z
    | _             -> S (to_nat (i-1));;

to_nat 10;;
to_nat 100;;

(* 
   to_nat 2 ====> S (to_nat (2-1)) 
            ====> S (to_nat 1)
            ====> S (S Z) 
 *)




(* write a plus function that takes two nats, 
   and returns a nat representing the sum of the two inputs *)
 
let rec plus n m = 
   match n with
   | Z -> m
   | S n' -> S (plus n' m)

let rec plus n m = 
   match n with
   | Z -> m
   | S n' -> (plus n' (S m))
















































let rec plus n m = 
  match n with
    | Z    -> m
    | S n' -> S (plus n' m);;


(*

Let's work through a call sequence:

call plus with
n == (S (S Z)) #2
m == S Z #1

plus (S (S Z)) (S Z)
S (plus (S Z) (S Z))
S (S (plus Z (S Z)))
S (S (S Z))
*)



(* some other ways to write it: *)
let rec plus n m =
        match (n,m) with 
        | (Z, m') -> m'
        | (n', Z) -> n'
        | (S n',S m') -> S (S (plus n' m'));;


(* yet another way *)
let rec plus n m = 
  match (n, m) with
    | (Z, Z)       -> Z
    | (Z, _)          -> m  
    | (_, Z)          -> n
    | (S n', S m') -> S (S (plus n'  m'));;


(* and yet another way *)
let rec plus n m = 
   match n with
   | Z -> m
   | S n' -> plus n' (S m);;


(* How to test? *)



























let int_plus n m = to_int (plus (to_nat n) (to_nat m));;

(* write mul for nats (hint: you can use plus) *)
let rec mul n m = 


























let rec mul n m = 
  match n with
    | Z    -> Z 
    | S n' -> plus m (mul n' m);;

let int_mul n m = to_int (mul (to_nat n) (to_nat m));;










let rec minus n m = ...


















let rec minus n m = 
  match (n, m) with
    | (Zero, _ )   -> Zero
    | (_, Zero)    -> n
    | (Succ n', Succ m') -> minus n' m';;

















type int_list = 
  | Nil 
  | Cons of (int * int_list) ;;



let rec length l = 
   match l with
   | Nil -> 0
   | Cons (h,t) -> 1 + length t;;

let rec sum l = 
   match l with
   | [] -> 0
   | h::t -> h+sum t;;

sum [1;2]
sum [2]
sum []

Stack {h:1,t:[2]} return 1+2 (=3)
Stack {h:2,t: []} ----  return 2+0 (=2)
Stack {} return 0




let sum l =
   let rec helper total remaining_list =
           match remaining_list with
           | [] -> total
           | h::t -> helper (h + total) t
   in helper 0 l;;


total = 0
remaining_list = t
while (remaining_list not empty)
{
  total = h+total
  remaining_list = t
}

total = 0
while (l!=null) {
        total = total + l.data
        l = l.next
}





























let rec length l = 
   match l with
   | Nil -> 0
   | Cons (i,t) -> 1 + length t;;

let rec length l =
   match l with
   | [] -> 0
   | h::t -> 1+length t;;

(*
How does it run?

len [2;3]

*)


let max x y = if x > y then x else y;;
let rec list_max xs =
   match xs with
   | [] -> None
   | h::t -> max h (list_max t);;

type int_maybe =
        | None 
        | Maybe of int;;
























let rec list_max xs = 
  match xs with
    | Nil           -> 0
    | Cons (x, xs') -> max x (list_max xs');;

let rec list_max xs = 
  match xs with
    | []           -> 0
    | x::xs' -> max x (list_max xs');;

(* another version that only works for non-empty lists *)
let rec list_max xs = 
  match xs with
   | [x] -> x
   | h::t -> max h (list_max t)


(* another way to handle the empty list *)
type int_maybe =
 | None
 | Some of int;;

let rec max_list l =

















let rec max_list l =
   match l with
   | [] -> None
   | h::t -> 
      match (max_list t) with
       | None -> Some h
       | Some i -> Some (max h i);;







let rec filter f xs = 

























let rec filter f xs = 
  match xs with
    | []     -> [] 
    | x::xs' -> let tl = filter f xs' in
                   if f x then x :: tl else tl;;


let rec filter f xs = 
  match xs with
    | []              -> [] 
    | x::xs' when f x -> x :: filter f xs'
    | _ :: xs'        -> filter f xs';;


(* bad ml style *)
let rec filter f xs = 
   if xs = [] then
      []
   else 
      let h = List.hd xs in
      let t = filter f (List.tl xs) in
      if f h then h::t else t;;




















type tree = Leaf of int | Node of tree * tree;;

let rec sum_leaves t = 




let rec double_leaves t =


























(* soln *)
let rec sum_leaves t = match t with
  | Leaf n      -> n
  | Node (l, r) -> sum_leaves l + sum_leaves r;;








(* how to test? *)
let create_tree height max = ...
























let rec create_tree height max =
   if height <= 0 then Leaf (Random.int max)
   else Node (create_tree (height-1) max, create_tree (height-1) max);;



(* let's define a type to represent artihmetic expressions *)
type expr =
  | Const of int
...



















(* soln *)
type expr =
        | Const of int
        | Sum of expr * expr
        | Mul of expr * expr;;




(* write eval function to evaluate an expression e *)

let rec eval e =
   match e with
   | Const c -> c
   | Sum (e1,e2) -> eval e1 + eval e2
   | Mul (e1,e2) -> eval e1 * eval e2;;
































(* soln *)

let eval e = 
        match e with
        | Const i -> i
        | Sum (e1,e2) -> (eval e1) + (eval e2)
        | Mul (e1,e2) -> (eval e1) * (eval e2)
