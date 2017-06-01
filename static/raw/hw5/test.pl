:- working_directory(CWD,CWD),atom_concat(CWD,'misc.pl',F),consult(F).

print_list([]).
print_list([H|T]) :- print(H), print_list(T).

print_exception(E) :- print_list(['exception: ',E]).
% print_exception(E) :- print_message(informational,E)

run_test(T,Max,Pts) :- print_list(['testing ',T,'... ']),
					   catch( ((not(not(T)),print('success'),Pts=Max);(print('fail'),Pts=0)), Ex, (print_exception(Ex),Pts=0) ),
					   print_list([' (',Pts,'/',Max,')']),nl,!.

run_tests([],Max,Pts) :- Max=0,Pts=0.
run_tests([run_test(T,TMax)|Ts],Max,Pts) :- run_test(T,TMax,TPts), run_tests(Ts,TsMax,TsPts), Max is TMax + TsMax, Pts is TPts + TsPts.

unordered_eq(A,B) :- msort(A,SA), msort(B,SB), !, SA=SB.

run_all_tests(Max,Pts) :- run_tests(
       [run_test(zip([1,2],[a,b],[1,a,2,b]),1),
	run_test((zip([1,2],[a,b],X),X=[1,a,2,b]),1),
	run_test((zip([1,2],[a,b],[1, 2, a, b])),1),
	run_test((zip([1,2],[a,b],[a, b, 1, 2])),1),
	run_test((zip([1,2],[a,b],[1, a, b, 2])),1),
	run_test((zip(X,[a,b],[1,a,2,b]),!,X=[1,2]),1),
	run_test((zip([1,2],X,[1,a,2,b]),!,X=[a,b]),1),
	run_test(assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],c,3),1),
	run_test(not(assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],f,_)),1),
	run_test(not(assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],_,99)),1),
	run_test((bagof(X,assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],b,X),Y),!,Y=[2,5]),1),
	run_test((bagof(X,assoc([[a,1],[b,2],[c,3],[d,1],[b,5]],X,1),Y),!,Y=[a,d]),1),
	run_test(remove_duplicates([1,2,3,4,2,3],[1,2,3,4]),1),
	run_test(not(remove_duplicates([1,2,3,4,2,3],[1,4,2,3])),1),
	run_test((remove_duplicates([1,2,3,4,2,3],X),!,X=[1,2,3,4]),1),
	run_test((union([1,2,3,4],[1,3,5,6],X),!,unordered_eq(X,[1,2,3,4,5,6])),1),
	run_test(not((union([1,2,3],[4,3],X),!,unordered_eq(X,[1,2,3]))),1),
	run_test((intersection([1,2,3,4],[1,3,5,6],X),!,unordered_eq(X,[1,3])),1),
	run_test(not(intersection([1,2,3],[4,3],[1])),1),
	
	run_test(not(available_at(lengua_sopa,el_cuervo)),1),
	run_test((bagof(X:Y,available_at(X,Y),Z),!,subset([carnitas_taco:el_cuervo,
	                                                   combo_plate:el_cuervo,
							   al_pastor_taco:el_cuervo,
							   carne_asada_burrito:el_cuervo,
							   birria_taco:la_posta,
							   adobado_burrito:la_posta],Z)),1),
	run_test((bagof(X,available_at(carnitas_taco,X),Y),!,unordered_eq(Y,[el_cuervo,robertos])),1),
	run_test(multi_available(carnitas_taco),1),
	run_test(not(multi_available(lengua_sopa)),1),
	run_test((bagof(X,multi_available(X),Y),!,unordered_eq(Y,[carnitas_taco,carne_asada_burrito,adobado_plate,combo_plate])),1),
	run_test(overworked(maria),1),
	run_test(not(overworked(carlos)),1),
	run_test((bagof(X,overworked(X),Y),!,unordered_eq(Y,[maria,miguel])),1),
	run_test(not(total_cost(carnitas_taco,3)),1),
	run_test((total_cost(carnitas_taco,X),!,X=5),1),
	run_test((bagof(X,total_cost(X,5),Y),!,unordered_eq(Y,[carnitas_taco,birria_taco])),1),
	run_test(not(has_ingredients(lengua_sopa,[cheese,lengua])),1),
	run_test((bagof(X,has_ingredients(X,[salsa,guacamole,cheese]),Y),!,unordered_eq(Y,[al_pastor_taco,combo_plate])),1),
	run_test(not(avoids_ingredients(lengua_sopa,[cheese,lengua])),1),
	run_test(avoids_ingredients(lengua_sopa,[cheese,tortilla]),1),
	run_test((bagof(X,avoids_ingredients(X,[guacamole]),Y),!,unordered_eq(Y,[al_pastor_burrito,lengua_sopa])),1),
	run_test((bagof(X,avoids_ingredients(X,[salsa,guacamole]),Y),!,unordered_eq(Y,[lengua_sopa])),1),
	run_test((find_items(X,[taco,guacamole],[cheese]),!,unordered_eq(X,[carnitas_taco,birria_taco,guacamole_taco])),1),
	run_test((find_items(X,[tortilla],[rice]),!,unordered_eq(X,[al_pastor_burrito])),1),
	run_test((find_items(X,[],[rice,guacamole]),!,unordered_eq(X,[al_pastor_burrito, lengua_sopa])),1),
	run_test((find_items(X,[rice,guacamole],[salsa]),!,unordered_eq(X,[carne_asada_burrito, adobado_burrito, adobado_plate])),1),
	run_test((find_items(X,[guacamole,cheese,salsa],[]),!,unordered_eq(X,[al_pastor_taco,combo_plate])),1)
    ],Max,Pts).
		
:- run_all_tests(Max,Pts), print_list(['Result: ',Pts,'/',Max]), nl, halt.
