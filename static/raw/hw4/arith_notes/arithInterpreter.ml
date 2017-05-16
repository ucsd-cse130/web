type aexpr =
  | Const of int
  | Var of string
  | Plus of aexpr * aexpr
  | Minus of aexpr * aexpr
  | Times of aexpr * aexpr
  | Divide of aexpr * aexpr

let rec eval env = function
  | Const i         -> i
  | Var s           -> List.assoc s env
  | Plus (e1, e2)   -> eval env e1 + eval env e2
  | Minus (e1, e2)  -> eval env e1 - eval env e2
  | Times (e1, e2)  -> eval env e1 * eval env e2
  | Divide (e1, e2) -> eval env e1 / eval env e2
