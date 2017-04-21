let max x y = if x < y then y else x;;

(* regular recursion *)
let rec max_list l =
  match l with
   | [] -> 0
   | h::t -> max h (max_list t);;

(* every recursive call, you take the return value and return it 
 * immediately!!! *)

max_list [1;7;2];;
















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
