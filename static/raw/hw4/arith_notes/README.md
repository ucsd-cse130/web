# Arithmetic expressions example from section

## Build 

```
$ cp arithParser1.mly arithParser.mly
$ make clean
$ make
```

## Test 

```
$ ./arith.top
# open Arith;;
  
# eval_string [] "2*3+5";;
# eval_string [("x", 500)] "x / 10";;
  
# let exp1 = parse_string "2*3+5";;
# Arith.eval [] exp1;;
  
# let exp2 = parse_string "x / 10";;
# Arith.eval [("x", 500)] exp2;;
```

