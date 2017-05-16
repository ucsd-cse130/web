let max x y = if x < y then y else x;;

(* regular recursion *)
let rec max_list l =
  match l with
   | [] -> 0
   | h::t -> max h (max_list t);;

(* every recursive call, you take the return value and return it
 * immediately!!! *)

(* maxList [1;7;2];;
   ==> 7
*)


let rec foldr op base xs =
  match xs with
   | []   -> base
   | h::t -> op h (foldr op base t)


foo1 = foldr max 0
foo2 = foldr (^) ""
foo3 = foldr (fun h n -> 1 + n) 0

(***********************************)

THREE = \f x -> f (f (f x))
FOUR  = \f x -> f (f (f (f x)))

let foldl op base  xs =
  let rec helper acc xs =
    match xs with
     | []   -> acc
     | h::t -> helper (op acc h) t
  in
    helper base xs

let maxList = foldl max 0
let concat  = foldl (^) ""
let length  = foldl (fun acc h -> acc + 1) 0

let maxList xs =
  let rec helper acc xs =
    match xs with
     | []   -> acc
     | h::t -> helper (max acc h) t
  in
    helper 0 xs

let concat xs =
  let rec helper acc xs =
    match xs with
     | []   -> acc
     | h::t -> helper (acc ^ h) t
  in
    helper "" xs

let length xs =
  let rec helper acc xs =
    match xs with
     | []   -> acc
     | h::t -> helper (acc + 1) t
  in
    helper 0 xs



let rec foo2 xs = match xs with
  | []     -> ""
  | (h::t) -> h ^ (foo2 t)

let rec foo3 xs = match xs with
  | []     -> 0
  | (h::t) -> 1 + foo3 t



(***********************************************************************)
type var  = string
type expr = Number of Int
          | Mul    of expr * expr
          | Add    of expr * expr
          | Var    of var
          | Let    of var * expr * expr 
(*
let x = 10 in
  let y = 20 in
    (2 + x)
    +
    (5 * y)
*)

let e = Let ("x", Number 10,
          Let ("y", Number 20,
            Add ( Add (Number 2 , Var "x")
                , Mul (Number 5 , Var "y")
                )
          )
         )

type environment = (var * int) list

val lookup : environment -> var -> int

(*
lookup [("x", 10); ("y", 20)] "x" = 10

lookup [("x", 10); ("y", 20)] "y" = 20

lookup [("x", 10); ("y", 20)] "z" = ??? (* THROWN EXCEPTION *)
*)

(* val eval : (expr * int * int) -> int *)
let rec eval e ???? = match e with
  | Number n     -> n
  | Add (e1, e2) -> eval (e1, x, y) + eval (e2, x, y)
  | Mul (e1, e2) -> eval (e1, x, y) * eval (e2, x, y)
  | VarX         -> x
  | VarY         -> y




(* concat ["one"; "seven"; "two"];;
   ==> "oneseventwo" *)


(*
concat                            []  =                    ""
concat                    ("two" :: []) =              "two"^""
concat         ("seven" :: "two" :: []) =         "seven"^"two"
concat ("one" :: "seven" :: "two" :: []) = "one" ^ "seven"^"two"
concat []         = ""
concat (w :: ws)  = w ^ (concat ws)
*)










(* tail recursive *)

let rec max_list l =
...
















(* soln *)

let rec max_list l =
   let rec helper max_so_far remaining_elmts =
          match remaining_elmts with
          | [] -> max_so_far
          | h::t -> helper (max max_so_far h) t
   in
   helper 0 l;;


max_list [1;3;2];;
helper 0 [1;3;2];;
helper 1 [3;2]
helper 3 [2]
helper 3 []

















(* regular recursion *)

let rec concat l =
   match l with
   | [] -> ""
   | h::t -> h ^ (concat t);;

(* tail recursion *)

let rec concat = ...






















(* soln *)

let rec concat l =
  let rec helper concat_so_far remaining_elmts =
          match remaining_elmts with
          | [] -> concat_so_far
          | h::t -> helper (concat_so_far^h) t
  in
  helper "" l;;

concat ["123";"abc"];;
helper "" ["123";"abc"]
helper "123" ["abc"]
helper "123abc" []







(* What's the pattern ?

   let rec helper max_so_far remaining_elmts =
          match remaining_elmts with
          | [] -> max_so_far
          | h::t -> helper (max max_so_far h) t

   let rec helper concat_so_far remaining_elmts =
          match remaining_elmts with
          | [] -> concat_so_far
          | h::t -> helper (concat_so_far^h) t

*)

(* extract pattern into an uber-helper function! *)


















(* soln*)
let rec fold f result_so_far remaining_elmts =
          match remaining_elmts with
          | [] -> result_so_far
          | h::t -> fold f (f result_so_far h) t;;




let list_max l = ...
let concat l = ...
let sum l = ...
let mult l = ...





















(* soln *)
let list_max l = fold max 0 l;;
let list_max = fold max 0;;
let concat = fold (^) "";;
let multiplier = fold (fun x y -> x * y) 1;;

let cons x y = y::x;;
let f = fold cons [];;

let rec reverse l =
        match l with
        | [] -> []
        | h::t -> (reverse t)@[h]

 (* What does f do? *)








(* return a list in which each element is produced from
 * the corresponding element in l by applying f *)
let rec map f l =
 ...


























(* soln *)
let rec map f l =
        match l with
        | [] -> []
        | h::t -> (f h)::(map f t);;


(* increment all ints in a list *)
map ...





















(* soln *)
map ((+) 1) [1;2;3];;
let f = (+) 5;;
map f [1;2;3]






let rec interval_init i j f =
        if i = j then [f i]
        else (f i)::interval_init (i+1) j f;;

let rec interval_init f i j =
        if i = j then [f i]
        else (f i)::interval_init f (i+1) j;;




(* implement map using fold *)
let map f l = ...























(* soln *)

let map f l =
   let base = [] in
   let fold_fn acc elmt = acc@[f elmt] in
   List.fold_left fold_fn base l;;

(* map f [] should return []
List.fold_left fold_fn base [] should return []
base should be [] *)

map f [1;2;3]


(* implement partition using fold *)
let partition f l =


























(* soln *)
let partition f l =
        let base = ([], []) in
        let fold_fn (x,y) elmt =
                if (f elmt)
                then (x@[elmt], y)
                else ( x, y@[elmt])
        in
        List.fold_left fold_fn base l;;

let compose f g = fun x -> f (g x)

let compose f g x = f (g x)

let map_incr = List.map ((+) 1);;
let map_incr_2 = compose map_incr map_incr;;
