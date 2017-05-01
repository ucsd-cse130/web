(* CSE 130: Programming Assignment 3 *)

(* For this assignment, you may use the following library functions:

   List.map
   List.fold_left
   List.fold_right
   List.split
   List.combine
   List.length
   List.append
   List.rev

   See http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html for
   documentation.
*)



(* Do not change the skeleton code! The point of this assignment is to figure
 * out how the functions can be written this way (using fold). You may only
 * replace the   failwith "to be implemented"   part. *)



(*****************************************************************)
(******************* 1. Warm Up   ********************************)
(*****************************************************************)

let sqsum xs = 
  let f a x = failwith "to be implemented" in
  let base = failwith "to be implemented" in
    List.fold_left f base xs

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE
let _ = sqsum []
let _ = sqsum [1;2;3;4]
let _ = sqsum [(-1); (-2); (-3); (-4)]
*)


let pipe fs = 
  let f a x = failwith "to be implemented" in
  let base = failwith "to be implemented" in
    List.fold_left f base fs


(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = pipe [] 3

let _ = pipe [(fun x -> x+x); (fun x -> x + 3)] 3

let _ = pipe [(fun x -> x + 3);(fun x-> x + x)] 3

*)


let rec sepConcat sep sl = match sl with 
  | [] -> ""
  | h :: t -> 
      let f a x = failwith "to be implemented" in
      let base = failwith "to be implemented" in
      let l = failwith "to be implemented" in
        List.fold_left f base l


(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = sepConcat ", " ["foo";"bar";"baz"]
let _ = sepConcat "---" []
let _ = sepConcat "" ["a";"b";"c";"d";"e"]
let _ = sepConcat "X" ["hello"]

*)


let stringOfList f l = failwith "to be implemented"

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = stringOfList string_of_int [1;2;3;4;5;6];;
let _ = stringOfList (fun x -> x) ["foo"];;
let _ = stringOfList (stringOfList string_of_int) [[1;2;3];[4;5];[6];[]];;

*)



(*****************************************************************)
(******************* 2. Big Numbers ******************************)
(*****************************************************************)

let rec clone x n = failwith "to be implemented" 

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = clone 3 5;;
let _ = clone "foo" 2;; 
let _ = clone clone (-3);;

*)

let padZero l1 l2 = failwith "to be implemented"

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = padZero [9;9] [1;0;0;2]
let _ = padZero [1;0;0;2] [9;9] 

*)

let rec removeZero l = failwith "to be implemented"

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = removeZero [0;0;0;1;0;0;2]
let _ = removeZero [9;9]
let _ = removeZero [0;0;0;0]

*)

let bigAdd l1 l2 = 
  let add (l1, l2) = 
    let f a x = failwith "to be implemented" in
    let base = failwith "to be implemented" in
    let args = failwith "to be implemented" in
    let (_, res) = List.fold_left f base args in
      res
  in 
    removeZero (add (padZero l1 l2))

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = bigAdd [9;9] [1;0;0;2];;
let _ = bigAdd [9;9;9;9] [9;9;9];; 

*)


let rec mulByDigit i l = failwith "to be implemented"

(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = mulByDigit 9 [9;9;9;9]

*)

let bigMul l1 l2 = 
  let f a x = failwith "to be implemented" in
  let base = failwith "to be implemented" in
  let args = failwith "to be implemented" in
  let (_, res) = List.fold_left f base args in
    res


(* UNCOMMENT AFTER IMPLEMENTING THE ABOVE

let _ = bigMul [9;9;9;9] [9;9;9;9]
let _ = bigMul [9;9;9;9;9] [9;9;9;9;9] 

*)






(*******************************************************************************)
(******************** DO NOT MODIFY ANYTHING AFTER THIS ************************)
(*******************************************************************************)


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
(* CSE 130 PA 3. Autotester *)

let key = "" (* change *)
let prefix130 = "130" (* change *)
let print130 s = print_string (prefix130^">>"^s)

exception ErrorCode of string

type result = Pass | Fail | ErrorCode of string

let score = ref 0
let max = ref 0
let timeout = 300

let runWTimeout (f,arg,out,time) = 
  try if compare (f arg) out = 0 then Pass else Fail
  with e -> (print130 ("Uncaught Exception: "^(Printexc.to_string e)^"\n"); ErrorCode "exception") 

exception TestException
let testTest () =
  let testGood x = 1 in
  let testBad x = 0 in 
  let testException x = raise TestException in
  let rec testTimeout x = testTimeout x in
    runWTimeout(testGood,0,1,5) = Pass &&  
    runWTimeout(testBad,0,1,5) = Fail &&  
    runWTimeout(testException,0,1,5) = ErrorCode "exception" && 
    runWTimeout(testTimeout,0,1,5) = ErrorCode "timeout"


let runTest (f,arg,out,points,name) =
  let _ = max := !max + points in
  let outs = 
	match runWTimeout(f,arg,out,timeout) with 
	    Pass -> (score := !score + points; "[pass]")
 	  | Fail -> "[fail]"
	  | ErrorCode e -> "[error: "^e^"]"  in
  name^" "^outs^" ("^(string_of_int points)^")\n"

(* explode : string -> char list *)
let explode s = 
  let rec _exp i = 
    if i >= String.length s then [] else (s.[i])::(_exp (i+1)) in
  _exp 0

let implode cs = 
  String.concat "" (List.map (String.make 1) cs)

let drop_paren s = 
  implode (List.filter (fun c -> not (List.mem c ['(';' ';')'])) (explode s))

let eq_real p (r1,r2) = 
  (r1 -. r2) < p || (r2 -. r1) < p

let wrap_curried_2 f (a,b) = f a b

let runAllTests () =
  let _ = (score := 0; max := 0) in
  let report = 
    [runTest (sqsum, [], 0, 1, "sqsum 1");
     runTest (sqsum, [1;2;3;4], 30, 1, "sqsum 2");
     runTest (sqsum, [-1;-2;-3;-4], 30, 1, "sqsum 3");

     runTest (wrap_curried_2 pipe, ([], 3), 3, 1, "pipe 1");
     runTest (wrap_curried_2 pipe, ([(fun x-> 2*x);(fun x -> x + 3)], 3), 9, 1, "pipe 2");
     runTest (wrap_curried_2 pipe, ([(fun x -> x + 3); (fun x-> 2*x)], 3), 12, 1, "pipe 3");

     runTest(wrap_curried_2 sepConcat, (", ",["foo";"bar";"baz"]), "foo, bar, baz", 1, "sepConcat 1");
     runTest(wrap_curried_2 sepConcat, ("---",[]), "", 1, "sepConcat 2");
     runTest(wrap_curried_2 sepConcat, ("",["a";"b";"c";"d";"e"]), "abcde", 1, "sepConcat 3");
     runTest(wrap_curried_2 sepConcat, ("X",["hello"]), "hello", 1, "sepConcat 4");

     runTest(wrap_curried_2 stringOfList, (string_of_int,[1;2;3;4;5;6]), "[1; 2; 3; 4; 5; 6]",1,"stringOfList 1");
     runTest(wrap_curried_2 stringOfList, ((fun x -> x),["foo"]), "[foo]",1,"stringOfList 2");
     runTest(wrap_curried_2 stringOfList, ((stringOfList string_of_int),[[1;2;3];[4;5];[6];[]]), "[[1; 2; 3]; [4; 5]; [6]; []]",1,"stringOfList 3");

     runTest(wrap_curried_2 clone, (3,5), [3;3;3;3;3],1,"clone 1");
     runTest(wrap_curried_2 clone, ("foo",2), ["foo";"foo"],1,"clone 2");
     runTest(wrap_curried_2 clone, (clone,-3), [],1,"clone 3");

     runTest(wrap_curried_2 padZero, ([9;9],[1;0;0;2]), ([0;0;9;9],[1;0;0;2]),1,"padzero 1");
     runTest(wrap_curried_2 padZero, ([1;0;0;2],[9;9]), ([1;0;0;2],[0;0;9;9]),1,"padzero 2");

     runTest(removeZero, [0;0;0;1;0;0;2], [1;0;0;2],1,"removeZero 1");
     runTest(removeZero, [9;9], [9;9],1,"removeZero 2");

     runTest(wrap_curried_2 bigAdd,  ([9;9],[1;0;0;2]), [1;1;0;1],1, "bigAdd 1");
     runTest(wrap_curried_2 bigAdd,  ([9;9;9;9],[9;9;9]), [1;0;9;9;8],1, "bigAdd 2");

     runTest(wrap_curried_2 mulByDigit,  (9,[9;9;9;9]), [8;9;9;9;1],1, "mulByDigit 1");

     runTest(wrap_curried_2 bigMul,  ([9;9;9;9],[9;9;9;9]), [9;9;9;8;0;0;0;1],1, "bigMul 1");
     runTest(wrap_curried_2 bigMul,  ([9;9;9;9;9],[9;9;9;9;9]), [9;9;9;9;8;0;0;0;0;1],1,"bigMul 2");
     ] in
  let s = Format.sprintf "Results: Score/Max = %d / %d \n" !score !max in
  let _ = List.iter print130 (report@([s])) in
    (!score,!max)
      
let _ = runAllTests ()
  
let _ = print130 ("Compiled"^key^"\n")


