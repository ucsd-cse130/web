type bexpr = And of bexpr * bexpr
           | Or of bexpr * bexpr
           | Xor of bexpr * bexpr
           | Neg of bexpr
           | Var of string
           | Const of bool

type binstr = Print of bexpr 
           | Assign of string * bexpr
