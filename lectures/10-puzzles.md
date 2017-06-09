
% Sum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	add(X,Y,Z) :- Z is X+Y.

% Fib %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fib(0, 1).
  fib(1, 1).
  fib(N, R) :- N1 is N-1, N2 is N-2, fib(N1, R1), fib(N2,R2), R is R1+R2.

% Factorial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	factorial(0,1). % base case
	factorial(X,N):- X1 is X-1, factorial(X1,N1), N is X1*N1.

We "call" the function with a query.

	?- factorial(0,X).
	X = 1
	True

	?- factorial(5,X).
	X = 12

	fac(0,1).
	fac(N,K):- N1 is N-1, fac(N1,K1), K is K1 * N.


% List-Basics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	headOf([H|_],H).

	tailOf([_|X],X).

	has3ormore([_,_,_|_]).

	barbaz([X,_,_,_,_,X|_]).


% List-Sum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	app([],Y,Y).
	app([Hx|Tx],Y,[Hx|T]) :- app(Tx,Y,T).

% List-Append %%%%%%%%%%%%%%%%%%

	app([],Y,Y).
	app([Hx|Tx],Y,[Hx|T]) :- app(Tx,Y,T).


% List-Member %%%%%%%%%%%%%%%%%%


	isin(X,[X|_]).
	isin(X,[_|T]) :- isin(X,T).



% List-Length %%%%%%%%%%%%%%%%%%



	len([],0).
	len([_|T],N) :- len(T,Nt), N is Nt + 1.









% List-Reverse %%%%%%%%%%%%%%%%%%


	rev(X,Y) :- acc_rev(X,Y,[]).
	acc_rev([],Y,Y).
	acc_rev([H|T],Y,SoFar) :- acc_rev(T,Y,[H|SoFar]).


% Hanoi %%%%%%%%%%%%%%%%%%

	move(A,B) :-
		nl, write('Move topdisk from '),
	        write(A), write(' to '), write(B).


	transfer(1,A,B,_) :- move(A,B).
	transfer(N,A,B,X) :-
		M is N-1,
		transfer(M,A,X,B),
		move(A,B),
		transfer(M,X,B,A).






% Farmer %%%%%%%%%%%%%%%%%%

		change(e,w).
		change(w,e).




		move([X,X,P_Goat,P_Cabbage],move_wolf,[Y,Y,P_Goat,P_Cabbage]) :- change(X,Y).
		move([X,P_Wolf,X,P_Cabbage],move_goat,[Y,P_Wolf,Y,P_Cabbage]) :- change(X,Y).
		move([X,P_Wolf,P_Goat,X],move_cabbage,[Y,P_Wolf,P_Goat,Y]) :- change(X,Y).
		move([X,P_Wolf,P_Goat,P_Cabbage],move_nothing,[Y,P_Wolf,P_Goat,P_Cabbage]) :- change(X,Y).


		one_equal(X,X,_).
		one_equal(X,_,X).






		safe([P_Farmer,P_Wolf,P_Goat,P_Cabbage]) :-
		     one_equal(P_Farmer,P_Goat,P_Wolf),
		     one_equal(P_Farmer,P_Goat,P_Cabbage).



		solution([e,e,e,e],[]).
		solution(State,[FirstMove|RemainingMoves]) :-
		     move(State,FirstMove,NextState),
		     safe(NextState),
		     solution(NextState,RemainingMoves).





		%    ?- length(X,7), solution([w,w,w,w],X).
