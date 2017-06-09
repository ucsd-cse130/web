---
title: Logic Programming II
headerImg: sea.jpg
---

## Numeric Computations: `add`

~~~~~{.prolog}
add(X,Y,Z) :- Z is X+Y.
~~~~~

We "call" the function with a query:

~~~~~{.prolog}
?- add(1,5,Z).
Z=6.

?- add(10,20,Z).
Z=30.
~~~~~

## Numeric Computations: `fibonacci`

First attempt.

~~~~~{.prolog}
fib(N, 0) :- 1.
fib(N, 1) :- 1.
fib(N, R) :- N1 is N-1, N2 is N-2, fib(N1, R1), fib(N2,R2), R is R1+R2.
~~~~~

Lets "call" it with a query:

~~~~~{.prolog}
?- fib(5, R).
R = 8
ERROR: Out of local stack
~~~~~

Oops. Why?

## Numeric Computations: `fibonacci`

Second attempt.

~~~~~{.prolog}
fib(N, 1) :- N < 2.
fib(N, R) :- N1 is N-1, N2 is N-2, fib(N1, R1), fib(N2,R2), R is R1+R2.
~~~~~

Lets "call" it with a query:

~~~~~{.prolog}
?- fib(5, R).
R = 8
R = 9
R = 10
R = 11
R = 12
R = 13
R = 14
R = 15 .
~~~~~

Say whaaaaaaaat?!


## Numeric Computations: `fibonacci`

Third attempt!

~~~~~{.prolog}
fib(N, 1) :- N < 2.
fib(N, R) :- 1 < N, N1 is N-1, N2 is N-2, fib(N1, R1), fib(N2,R2), R is R1+R2.
~~~~~

Again, "call" it with a query

~~~~~{.prolog}
?- fib(5, R).
R = 8.
~~~~~

Fingers crossed!

~~~~~{.prolog}
?- fib(5, R).
R = 8
false.
~~~~~

## Numeric Computations: `factorial`

Which of the following is a _correct_ implementation of `factorial`?

~~~~~{.prolog}
% A
factorial(1,1).
factorial(N,R) :- N1 is N-1, factorial(N1,R1), R is N * R1.

% B
factorial(N,1) :- N < 2.
factorial(N,R) :- N1 is N-1, factorial(N1,R1), R is N * R1.

% C
factorial(N,1) :- N < 2.
factorial(N,R) :- 1 < N, N1 is N-1, factorial(N1,R1), R is N * R1.

% D
factorial(N,R) :- 1 < N, N1 is N-1, factorial(N1,R1), R is N * R1.
factorial(N,1) :- N < 2.
~~~~~


## Lists

In prolog a list is "built-in".

- Of course, also _just a term_.

~~~~~{.prolog}
?- [H|T] = [1,2,3].
H = 1,
T = [2, 3].
~~~~~

Feels just like ML style pattern matching!

## Lists: `head` and `tail`

We have to write them as predicates

- With an extra output parameter

~~~~~{.prolog}
headOf([H|_], H).

tailOf([_|T], T]).
~~~~~


## Lists: `hasThreeOrMore`

We want a predicate such that:

~~~~~{.prolog}
?- hasThreeOrMore([]).
false.

?- hasThreeOrMore([1]).
false.

?- hasThreeOrMore([1,two]).
false.

?- hasThreeOrMore([1,two,dog]).
true

?- hasThreeOrMore([1,two,dog,[7]]).
true.
~~~~~


Which of these is an implementation of such a predicate?

~~~~~{.prolog}
?- hasThreeOrMore([_|_]).					% A
?- hasThreeOrMore([_,_|_]).				% B
?- hasThreeOrMore([_,_,_|_]).     % C
?- hasThreeOrMore([_,_,_,_|_]).   % D
?- hasThreeOrMore([_,_,_]).       % E
~~~~~~

## Lists: `isIn`

Lets write a predicate to check if `X` is in some list `Xs`.

~~~~~{.prolog}
isIn(X,Xs) :- TODO-IN-CLASS.
~~~~~

## Lists: `len`

Lets write a "function" to add up the elements of a list

~~~~~{.prolog}
len(Xs, R).
~~~~~

## Lists: `sum`

Lets write a "function" to add up the elements of a list

~~~~~{.prolog}
sum(Xs, R) :- TODO-IN-CLASS.
~~~~~

## Lists: `append`

Lets write a "function" to append *two* lists.

~~~~~{.prolog}
append(Xs, Yz, R) :- TODO-IN-CLASS.
~~~~~

Unlike elsewhere, the prolog append is a **magical**.

~~~~~{.prolog}
  ?- append([1,2,3], [4,5,6], R).
~~~~~

## Lists: `reverse`

~~~~~{.prolog}
reverse(X, Y) :- revAcc(X,Y,[]).

revAcc([], Y, Y).
revAcc([H|T], Y, Acc) :- revAcc(T, Y, [H|Acc]).
~~~~~


## Puzzle: Farmer, Wolf, Goat, Cabbage.

![Gotham](/static/img/gotham.jpg){#fig:gotham .align-center width=75%}

<br>

![Fargo](/static/img/fargo.jpg){#fig:fargo .align-center width=75%}


## Puzzle Farmer, Wolf, Goat, Cabbage

~~~~~{.prolog}
change(east, west).
change(west, east).
~~~~~


~~~~~{.prolog}
move([X,X,P_Goat,P_Cabbage],move_wolf,[Y,Y,P_Goat,P_Cabbage]) :- change(X,Y).
move([X,P_Wolf,X,P_Cabbage],move_goat,[Y,P_Wolf,Y,P_Cabbage]) :- change(X,Y).
move([X,P_Wolf,P_Goat,X],move_cabbage,[Y,P_Wolf,P_Goat,Y]) :- change(X,Y).
move([X,P_Wolf,P_Goat,P_Cabbage],move_nothing,[Y,P_Wolf,P_Goat,P_Cabbage]) :- change(X,Y).
~~~~~


~~~~~{.prolog}
safe([P_Farmer,P_Wolf,P_Goat,P_Cabbage]) :-
	one_equal(P_Farmer,P_Wolf,P_Goat),
	one_equal(P_Farmer,P_Goat,P_Cabbage).

one_equal(X,X,_).
one_equal(X,_,X).
~~~~~

~~~~~{.prolog}
solution([east,east,east,east],[]).
solution(State,[FirstMove|RemainingMoves]) :-
	move(State,FirstMove,NextState),
	safe(NextState),
	solution(NextState,RemainingMoves).
~~~~~

And now we solve it!

~~~~~{.prolog}
?- length(Moves, 7), solution([west,west,west,west], Moves).
~~~~~
