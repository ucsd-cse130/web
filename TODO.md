# TODO

- lectures/00-intro.markdown
- homeworks/00-warmup.markdown
- groups.md
- seating.pdf




let collapse f gs =
[ (k, foldl  v vs)  | (k, v:vs) <- gs ]

collapse (+) gs   = [ (k, foldl (+) v vs) | (k, v:vs) <- gs ]

  List.map (fun (k, v::vs) -> (k, List.fold_left f v vs)) gs


let collapse f gs =
  List.map f [g1, ... , gn]
  == [f g1, ... , f gn]

  collapse (+) [(k1, vs1),...,(kn, vsn)]
  = [(k1, foldleft (+) vs1),...,(kn, foldleft (+) vsn)]
