
let _ =
  let x = 5 in
  let f y = x + y + (f 0) in
  let _ = Format.printf "%d\n" (f 10) in
  let _ = let x = 6 in Format.printf "%d\n" (f 10) in
  let _ = Format.printf "%d\n" (f 10) in
  ()


(* What does this print?

A. 15 16 16

B. 15 15 15

C. 15 16 15

D. None of the above

 *)


(* The above program as data

Let ("x", 5,
 Let ("f", Fun ("y", Plus (Var "x", Var "y")),
  (* A *)
  Let ("_", Print (App (Var "f", Const 10)),
  Let ("_", Let ("x", Const 6,
              (* B *)
             Print (App (Var "f", Const 10)))),
  (* C *)
  Let ("_", Print (App (Var "f", Const 10)),
  ())))

 *)


(* Mutable Variables, AKA Option A

A:
| var | value | ref | value          |
|-----+-------+-----+----------------|
| x   | $1    | $1  | 5              |
| f   | $2    | $2  | fun y -> x + y |

B:
| var | value | ref | value          |
|-----+-------+-----+----------------|
| x   | $1    | $1  | 6              |
| f   | $2    | $2  | fun y -> x + y |

C:
| var | value | ref | value          |
|-----+-------+-----+----------------|
| x   | $1    | $1  | 6              |
| f   | $2    | $2  | fun y -> x + y |

*)


(* Dynamic Scope, AKA Option C
A:
| var | value          |
|-----+----------------|
| x   | 5              |
| f   | fun y -> x + y |

B:
| var |          value |
|-----+----------------|
| x   |              5 |
| f   | fun y -> x + y |
| x   |              6 |

C:
| var |          value |
|-----+----------------|
| x   |              5 |
| f   | fun y -> x + y |

 *)


(* Lexical Scope, AKA Option B

A:
| var | value                     |
|-----+---------------------------|
| x   | 5                         |
| f   | fun y -> x + y, where x=5 |
                            v
   +------------------------+
   v
| var | value |
| x   |     5 |

B:
| var | value                     |
|-----+---------------------------|
| x   | 5                         |
| f   | fun y -> x + y, where x=5 | >+
| x   | 6                         |  |
                                     |
   +---------------------------------+
   v
| var | value |
| x   |     5 |

C:
| var | value                     |
|-----+---------------------------|
| x   | 5                         |
| f   | fun y -> x + y, where x=5 |
                            v
   +------------------------+
   v
| var | value |
| x   |     5 |


*)


(* What if `f` were recursive, e.g.

let _ =
  let x = 5 in
  let rec f y = x + y + (f 0) in
    (* A *)
  let _ = Format.printf "%d\n" (f 10) in
  let _ = let x = 6 in Format.printf "%d\n" (f 10) in
  let _ = Format.printf "%d\n" (f 10) in
  ()

A:
| var | value                     |
|-----+---------------------------|
| x   | 5                         |
| f   | fun y -> x + y, where x=5 | >+
                                     |
   +---------------------------------+
   v
| var | value                     |
| x   | 5                         |
| f   | fun y -> x + y, where x=5 | >+
                                     |
   +---------------------------------+
   v
| var | value                     |
| x   | 5                         |
| f   | fun y -> x + y, where x=5 | >+
                                     |
   +---------------------------------+
   v
  ...

*)
