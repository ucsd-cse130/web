(*
 * expressions
 * values
 * environments
 *
 *)

type binop = Plus | Times | Or

type value = Int of int
  | Bool of bool

type exp = IConst of int
  | BConst of bool
  | Bin of exp * binop * exp
  | Var of string
  | Let of string * exp * exp

type env = (string * value) list

type program = (string * exp) list

let listAssoc k l = List.fold_left (fun r (t,v) -> 
	if r=None && k=t then Some v else r) None l

let p1 = [("x",Bin(IConst 3,Plus,IConst 4));  (* x = 3+4 *)
		  ("y",Bin(Var "x",Plus,Var "x"));    (* y = x+x *)
		  ("z",BConst false);
		  ("w",Bin(Var "z",Or,BConst true));
		  ("a",Let("x",IConst 10,Bin(Var "x",Plus,Var "x")))]
		
let rec eval_exp evn e = 
	match e with
		IConst i -> Int i
	  | BConst b -> Bool b
	  | Bin(e1,op,e2) -> let v1=eval_exp evn e1 in
			let v2 = eval_exp evn e2 in
				(match (v1,op,v2) with
					(Int i1,Plus,Int i2) -> Int (i1+i2)
				  | (Int i1,Times,Int i2) -> Int (i1*i2)
				  | (Bool b1,Or,Bool b2) -> Bool (b1||b2)
				  | _ -> failwith "bad types for binary operator")
	  | Var x -> (match listAssoc x evn with
					Some v -> v
				  | None -> failwith "variable not bound")
	  | Let(x,e1,e2) -> let v1 = eval_exp evn e1 in
			let new_evn = (x,v1)::evn in
				eval_exp new_evn e2

let rec eval_program evn p = 
	match p with
		[] -> evn
	  | ((x,e)::t) -> let v = eval_exp evn e in
	        let new_evn = (x,v)::evn in
	 			eval_program new_evn t
