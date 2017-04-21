2;;

2 + 2;;

2 * (9 + 10) ;;

2 * (9 + 10) - 12;;
































"ab";;

"ab"^"xy";;



































true;;

false;;

1 < 2;;

"aa" = "pq";;

"aa" = "pq" && 1 < 2 ;;

"aa" = "pq" || 1 < 2 ;;





























(2+3) || ("a" = "b");;

"pq" ^ 9;;

(2+"a");;

























(2+2,7>8);;

(9-3,"ab"^"cd",(2+2 ,7>8));;

fst (2+2,7>8);;

snd (2+2,7>8);;






























[];;

[1;2;3];;

[1,2,3];;



























[1+1;2+2;3+3;4+4];;





























["a";"b";"c"^"d"];;

[(1,"a"^"b");(3+4,"c")];;

[[1];[2;3];[4;5;6]];;

[1;"pq"];;



















(* What can we do with lists? *)

(* constructor 1: cons *)

1::[];;

1::[2];;

"a"::["b";"c"];;

1::["b";"cd"];;


















(* constructor 2: append *)

[1;2]@[3;4;5];;

["a"]@["b"];;

[]@[1];;

1@[2;3];;

[1]@["a";"b"];;

(* destructors? *)





















List.hd [1;2];;

List.tl [1;2;3];;

List.tl [];;

























let x = 2 + 2;;

let y = x * x * x;;

let z = [x;y;x+y];;

let p = a + 1;;


























let tempVar = x + (2 * y) in
tempVar * tempVar;;

tempVar;;










let y = 
  let tempVar = x + (2 * y) in
  tempVar * tempVar
;;

[(let tempVar = x + (2 * y) in tempVar * tempVar);5];;

tempVar;;
 















let (x,y,z) = (2+3,"a"^"b", 1::[2]);;















let h::t = [1;2;3];;


let l = [1;2;3];;
let h::t = l;;






















let h::t = [];;












let (x,h::t) = ("Hello", [1;2;3;4]);;















let l = [1;2;3];;

match l with
  | [] -> true
  | h::t -> false;;




let l = [] in
match l with
  | [] -> true
  | h::t -> false;;



let x =
match l with
  | [] -> (0,[])
  | h::t -> (h,t);;
















let inc = fun x -> x+1 ;; 

inc 0;;

inc 10;;

let double = fun x -> x*2 ;;

double 0;;
double 3;;

double 2+2;;




















(* Note: double 2+2 is parsed as (double 2)+2 *)

double (2+2) ;;


(* let's say we want a function that returns true if the given list empty *)

let is_empty = 



















let is_empty l = 
    match l with
      | [] -> true
      | h::t -> false;;





let is_empty = fun l -> 
                match l with
                  | [] -> true
                  | h::t -> false;;  

(* How do we do multiple params? *)


























let plus = fun (x,y) -> x + y;;


















let plus = fun p -> 
        let (x,y) = p in x+y;;

plus (4,5);;

let lt = fun (x,y) -> x < y;;

let lt = fun p -> 
      let (x,y) = p in x < y

lt (5,2);;

lt (5,10);;

(* But... there is another way... *)
























let plus = fun x -> fun y -> x + y ;;



















(plus 5) 10;;

let inc = plus 1;;









let lt = fun x -> (fun y -> x < y);;

let is5lt = lt 5;;

is5lt 10;;

is5lt 2;;





































let neg = fun f -> fun x -> not (f x);;














let is5gte = neg is5lt ;;

is5gte 10;;

is5gte 2;;

let odd = fun x -> x mod 2 = 1;;

odd 2;;

odd 5;;

let even = neg odd;;

even 2;;

even 5;;









let plus = fun x -> (fun y -> x+y);;

let plus x y = x + y;;










(* previous: let neg = fun f -> fun x -> not (f x);; *)
(* Same as: *)

let neg f x = not (f x);;

(* and it all works as before: *)

let is5gte = neg is5lt ;;

is5gte 10;;

is5gte 2;;

let even =  neg odd;;

even 3;;

even 8;;





(* note that it's not the same as the following: *)

let other_neg (f,x) = not (f x);;

let is5gte = other_neg is5lt ;;



































let rec filter f l = 
   match l with 
    | []     -> []
    | (h::t) -> 
           let t' = (filter f t) in
           if f h then h::t' else t';;


let list1 = [1;31;12;4;7;2;10];;

filter is5lt list1;;

filter is5gte list1;;

filter even list1;;


















let partition f l = (filter f l, filter (neg f) l);;

partition is5lt list1;;

partition even list1;;





























2 < 3 ;;


"ba" < "ab" ;;


let lt = (<) ;;


lt 2 3 ;;


lt "ba" "ab" ;;


let is5lt = lt 5 ;;


is5lt 10;;


is5lt 2;;






















let rec sort l = 
  match l with 
  | []     -> []
  | (h::t) -> let (l,r) = partition ((>) h) t in
              (sort l)@(h::(sort r));;

sort list1;;

sort ["p";"a";"z";"q";"r";"b"];;






