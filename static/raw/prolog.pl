
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% List of parent relationships parent(kim,holly).  parent(margaret,kim).  
parent(herbert,margaret). parent(john,kim). parent(felix,john).  
parent(albert,felix). parent(albert,dana). parent(felix,maya).



grandparent(X,Y) :- parent(X,Z), parent(Z,Y).

greatgrandparent(X,Y) :- parent(X,Z),grandparent(Z,Y).







has_family(X) :- parent(X,_).
has_family(X) :- parent(_,X).








ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(Z,Y),ancestor(X,Z).






ancestor1(X,Y) :- ancestor1(X,Z), parent(Z,Y).
ancestor2(X,Y) :- parent(X,Y).








ancestor2(X,Y) :- parent(Z,Y),ancestor2(X,Z).
ancestor2(X,Y) :- parent(X,Y).


sib(X,Y) :- parent(Z,X), parent(Z,Y).








sibling1(X,Y) :- not(X=Y),parent(P,X),parent(P,Y).

sibling2(X,Y) :- parent(P,X), parent(P,Y),not(X=Y).

sibling3(X,Y) :- X\=Y,parent(P,X),parent(P,Y).






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

fac(0,1).
fac(N,K):- N1 is N-1, fac(N1,K1), K is K1 * N.


app([],Y,Y).
app([Hx|Tx],Y,[Hx|T]) :- app(Tx,Y,T).









tailof([_|X],X).







has3ormore([_,_,_|_]).










barbaz([X,_,_,_,_,X|_]).











isin(X,[X|_]).
isin(X,[_|T]) :- isin(X,T).









len([],0).
len([_|T],N) :- len(T,Nt), N is Nt + 1.











rev(X,Y) :- acc_rev(X,Y,[]).
acc_rev([],Y,Y).  
acc_rev([H|T],Y,SoFar) :- acc_rev(T,Y,[H|SoFar]).






foo(a).  
foo(b). 
foo(c).
foo(d).





allfoos(L) :- listallfoos(L,[]).





listallfoos([X|L],SoFar) :- 
	foo(X),    
        not(isin(X,SoFar)),
        append(SoFar,[X],NewSoFar),
        listallfoos(L,NewSoFar).
     
listallfoos([],_).    


move(A,B) :- 
	nl, write('Move topdisk from '),
        write(A), write(' to '), write(B). 


transfer(1,A,B,_) :- move(A,B).
transfer(N,A,B,X) :-
	M is N-1,
	transfer(M,A,X,B),
	move(A,B),
	transfer(M,X,B,A).












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





