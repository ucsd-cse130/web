---
title: HW 5, due 6/11/2017 (150 points)
headerImg: angles.jpg
---

## Installing Prolog

To run SWI-Prolog in the lab see [this page](/lectures/info_prolog.html)

To download and install SWI-Prolog on your home machines see
[this page](http://www.swi-prolog.org).
Remember that this is only to enable you to play with the assignment
at home: The final version turned in must work on the ACS Linux
machines. While you can use Windows to begin working with Prolog,
the code you turn in must be that required for the ACS Linux environment.

## Overview

The overall objective of this assignment is for you to gain some
hands-on experience with problem solving using Prolog, using simple
facts and rules, recursion, and database handling capabilities of the
language. So as not to make the code overly long, it is not required
that you deal with user errors: you can assume that the user always
types valid commands (e.g., if a predicate is supposed to take an atom
as argument, you do not have to check whether the argument is instead
a list and throw an error). Note that the Prolog interpreter catches
a good number of user errors anyway.

**Download** the assignment as this single file

- [hw5.zip](/static/raw/hw5.zip)

When you unzip it, you should see two files

- [misc.pl](/static/raw/hw5/misc.pl) which contains
  several skeleton Prolog rules with missing bodies
  that you have to fill in (that is, replace `throw(to_be_done)`
  with the definitions for the predicate.

- [test.pl](/static/raw/hw5/test.pl) which contains
  a very small suite of tests which gives you a
  flavor of of these tests.

## Assignment Testing and Evaluation

Your functions/programs **must** compile and/or run
on a **ACS Linux** machine (e.g. `ieng6.ucsd.edu`)
as this is where your solutions will be checked.
While you may develop your code on any system, ensure
that your code runs as expected on an ACS machine prior
to submission. You should test your code in the directories
from which the zip files (see below) will be created, as
this will approximate the environment used for grading the
assignment.


## Submission Instructions

You will turn in your solution, by filling in the template file
[misc.pl](/static/pa7/misc.pl). This file is submitted using
`turnin` as follows:

~~~~~{.bash}
 turnin -c cs130s -p 05 misc.pl
~~~~~

`turnin` will provide you with a confirmation of the
submission process; make sure that the size of the file
indicated by `turnin` matches the size of your zip file.
See the ACS Web page on [turnin](http://acs.ucsd.edu/info/turnin.php)
for more information on the operation of the program.

## Hints

Read the Prolog documentation shown [here](/links.html), and you
should use the functions `isin`, `append`, `reverse` and `bagof`
judiciously.

## Problem 1: Lists

### (a) 5 points
Write a Prolog predicate `zip(L1,L2,L3)` that is true if the *list*
`L3` is obtained by zipping (i.e. ``shuffling", or ``interleaving")
the elements of the lists `L1` and `L2`, which can have different lengths.
For instance, when you are done, you should get the following behavior:

~~~~~{.prolog}
?- zip([1,2],[a,b],[1,a,2,b]).
true.

?- zip([1,2],[a,b],X).
X = [1, 2, a, b] ;
X = [1, 2, a, b] ;
X = [1, a, 2, b] ;
X = [1, a, b, 2] ;
X = [a, 1, 2, b] ;
X = [a, 1, b, 2] ;
X = [a, b, 1, 2] ;
X = [a, b, 1, 2] ;
false.

?- zip([1,2],[a,b],[1,2,a,b]).
true.

?- zip(X,[a,b],[1,a,2,b]).
X = [1,2]
true.

?- zip([1,2],X,[1,a,2,b]).
X = [a,b]
true.
~~~~~

### (b) 10 points

Next, implement *associative lists* (i.e. lookup tables) in Prolog.
Write a Prolog predicate `assoc(L,X,Y)`, such that
`assoc([[k1,v1],[k2,v2],...,[kn,vn]],X,Y)` is true if `X`
equals some `ki` and `Y` equals the corresponding `vi`.
When you are done, you should get the following behavior:

~~~~~{.prolog}
?- assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],c,3).
true.

?- assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],f,Y).
false.

?- assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],X,99).
false.

?- assoc([[a,1],[b,2],[c,3],[d,4],[b,5]],b,Y).
Y = 2 ;
Y = 5
false.

?- assoc([[a,1],[b,2],[c,3],[d,1],[b,5]],X,1).
X = a ;
X = d
false.
~~~~~

### (c) 20 points

Write a Prolog predicate `remove_duplicates(L1,L2)` that is true if
`L2` is equal to the result of removing all duplicate elements from
`L1`. In the result, the order of the elements must be the same as
the order in which the (first occurences of the) elements appear in `L1`.
When you are done, you should get the following behavior:

~~~~~{.prolog}
?- remove_duplicates([1,2,3,4,2,3],[1,2,3,4]).
true.

?- remove_duplicates([1,2,3,4,2,3],[1,4,2,3]).
false.

?- remove_duplicates([1,2,3,4,2,3], X).
X = [1,2,3,4]
~~~~~


### (d) 10 points

Write a Prolog predicate `union(L1,L2,L3)` that is true if `L3`
is equal to the list containing the *union* of the elements in
`L1` and `L2` without any duplicates. In other words, the
elements of `L3` are those that occur in either `L1` or in
`L2`. When you are done, you should get the following behavior:

~~~~~{.prolog}
?- union([1,2,3,4],[1,3,5,6],[1,2,3,4,5,6]).
true.

?- union([1,2,3,4],[1,3,5,6],X).
X = [1,2,3,4,5,6].

?- union([1,2,3,4],[1,3,5,6],X).
X = [1,2,3,4,5,6].

?- union([1,2,3],[4,3],[1,2,3]).
false.
~~~~~

As shown in in the third example above, your predicate may be
true only for one particular order of the elements of `L3` (i.e.
it need not cycle through all permutations of the elements.)


### (e) (20 Points)

Write a Prolog predicate `intersection(L1,L2,L3)` that is true if
`L3` is equal to the list containing intersection of the
elements in `L1` and `L2` without any duplicates. In other
words, `L3` should contain the elements that both in `L1`
and in `L2`. As for `union` the predicate must be true for *some*  
order of elements of the intersection (but not necessarily all).
When you are done, you should get the following behavior:

~~~~~{.prolog}
?- intersection([1,2,3,4],[1,3,5,6],[1,3]).
true.

?- intersection([1,2,3,4],[1,3,5,6],X).
X = [1,3].

?- intersection([1,2,3,4],[1,3,5,6], X).
X = [1,3] ;
false.
?- intersection([1,2,3],[4,3],[1]).
false.
~~~~~

As shown in in the third example above, your predicate may be true
only for one particular order of the elements of `L3`.

## Problem 2: Taqueria Database

Prolog can be used as a sophisticated database system in which data is
stored in the form of structured predicates. In this problem we consider a
database of taquerias that sell various items, for a variety of budgets and
palates. First, we have a set of facts that encode the price of different
ingredients. For example, the first fact stipulates that a serving of carne
asada costs 6 dollars (this is high-quality, organic, grass-fed beef).

~~~~~{.prolog}
cost(carne_asada,6).
cost(lengua,2).
cost(birria,2).
cost(carnitas,2).
cost(adobado,2).
cost(al_pastor,2).
cost(guacamole,1).
cost(rice,1).
cost(beans,1).
cost(salsa,1).
cost(cheese,1).
cost(sour_cream,1).
cost(taco,1).
cost(tortilla,1).
~~~~~

Next, we have a list of menu items, and for each item, we have a fact that
tells us which ingredients go into the item. For example, the carnitas
taco, is a tasty snack comprising carnitas, salsa and guacamole,
generously stuffed into a fresh taco.

~~~~~{.prolog}
ingredients(carnitas_taco,
            [taco,carnitas, salsa, guacamole]).
ingredients(birria_taco,
            [taco,birria, salsa, guacamole]).
ingredients(al_pastor_taco,
            [taco,al_pastor, salsa, guacamole, cheese]).
ingredients(guacamole_taco,
            [taco,guacamole, salsa,sour_cream]).
ingredients(al_pastor_burrito,
            [tortilla,al_pastor, salsa]).
ingredients(carne_asada_burrito,
            [tortilla,carne_asada, guacamole, rice, beans]).
ingredients(adobado_burrito,
            [tortilla,adobado, guacamole, rice, beans]).
ingredients(carnitas_sopa,
            [sopa,carnitas, guacamole, salsa,sour_cream]).
ingredients(lengua_sopa,
            [sopa,lengua, salsa, beans,sour_cream]).
ingredients(combo_plate,
            [al_pastor, carne_asada,rice, tortilla, beans, salsa, guacamole, cheese]).
ingredients(adobado_plate,
            [adobado, guacamole, rice, tortilla, beans, cheese]).
~~~~~

Finally, we the database has a set of facts specifying the different
taqueries, and for each taqueria, the list of employees, and the list
of delectable comestibles available for purchase at the taqueria.

~~~~~{.prolog}
taqueria(el_cuervo, [ana,juan,maria],
        [carnitas_taco, combo_plate, al_pastor_taco, carne_asada_burrito]).

taqueria(la_posta,
        [victor,maria,carla], [birria_taco, adobado_burrito, carnitas_sopa, combo_plate, adobado_plate]).

taqueria(robertos, [hector,carlos,miguel],
        [adobado_plate, guacamole_taco, al_pastor_burrito, carnitas_taco, carne_asada_burrito]).

taqueria(la_milpas_quatros, [jiminez, martin, antonio, miguel],  
        [lengua_sopa, adobado_plate, combo_plate]).
~~~~~

The first store has three employees and sells four different items, the
second store has three employees and sells five different items, and so on.
You can assume that there are no duplicates (eg `carnitas` is not
listed twice in any ingredient list, `maria` is not listed twice
in any employee list, the same menu item is is not listed twice in any
store menu, etc.).  Given a database of facts, the questions below
have you write predicates that implement queries to the database.

### (a) (5 Points)

Write a Prolog predicate `available_at(X,Y)` that is true if the item
`X` is available at the taqueria `Y`. When you are done, you should get
the following behavior:

~~~~~{.prolog}
?- available_at(lengua_sopa,el_cuervo).
false.

?- available_at(X,Y).
X = carnitas_taco
Y = el_cuervo;  

X = combo_plate
Y = el_cuervo ;

X = al_pastor_taco
Y = el_cuervo ;

X = carne_asada_burrito
Y = el_cuervo ;

X = birria_taco
Y = la_posta ;

X = adobado_burrito
Y = la_posta.
~~~~~

Similarly, if one has a hankering for a carnitas taco, one can query the
database thus:

~~~~~{.prolog}
?- available_at(carnitas_taco,Y).
Y = el_cuervo ;
Y = robertos.
~~~~~

### (b) 7 Points

Write a Prolog predicate `multi_available(X)` that is true if the
item `X` is available at more than one place. For example:

~~~~~{.prolog}
?- multi_available(carnitas_taco).
true.

?- multi_available(lengua_sopa).
false.

?- multi_available(X).
X = carnitas_taco ;
X = carne_asada_burrito ;
X = adobado_plate ;
X = combo_plate .
~~~~~


### (c) 8 Points
Write a Prolog predicate `overworked(X)` that is true the person
`X`  works at more than one taqueria. For instance:

~~~~~{.prolog}
?- overworked(maria).
true.

?- overworked(carlos).
false.

?- overworked(X).
X = maria ;
X = miguel .
~~~~~


### (d) 15 Points

Write a Prolog predicate `total_cost(X,K)` that is true if the
sum of the costs of the ingredients of item `X` is equal to
`K`. When you are done, you should get the following:

~~~~~{.prolog}
?- total_cost(carnitas_taco,3).
false.

?- total_cost(carnitas_taco,X).
X = 5.

?- total_cost(X,5).
X = carnitas_taco ;
X = birria_taco.
~~~~~

### (e) 15 Points
Write a Prolog predicate `has_ingredients(X,L)` that is true if
the item `X` has all the ingredients listed in `L`.
When you are done, you should get the following:

~~~~~{.prolog}
?- has_ingredients(lengua_sopa,[cheese,lengua]).
false.

?- has_ingredients(X,[salsa,guacamole,cheese]).</font><br>
X = al_pastor_taco ;
X = combo_plate.
~~~~~

### (f) 15 Points

Write a Prolog predicate `avoids_ingredients(X,L)` that is true if
the item `X` does not have *any of* the ingredients listed in `L`.
When you are done, you should get the following:

~~~~~{.prolog}
?-avoids_ingredients(lengua_sopa,[cheese,lengua]).
false.

?- avoids_ingredients(lengua_sopa,[cheese,tortilla]).
true.

?- avoids_ingredients(X,[guacamole]).
X = al_pastor_burrito ;
X = lengua_sopa.

?- avoids_ingredients(X,[salsa,guacamole]).
X = lengua_sopa.
~~~~~


### (g) 10 + 10 Points

In the given file, we have filled in an implementation for a predicate
`find_items(L,X,Y)` that is true if `L` is the list of
*all items* that contain all the ingredients in `X` and do
not contain any of the ingredients in `Y`.
This predicate is specified using two helper predicates `p1`, `p2`
that *you* must implement, to obtain a complete specification for
`find_items`. When you are done, you should obtain the following results:

~~~~~{.prolog}
?- find_items(X,[taco,guacamole],[cheese]).
X = [carnitas_taco, birria_taco, guacamole_taco].

?- find_items(X,[tortilla],[rice]).
X = [al_pastor_burrito].

?- find_items(X,[],[rice,guacamole]).
X = [al_pastor_burrito, lengua_sopa].

?- find_items(X,[rice,guacamole],[salsa]).
X = [carne_asada_burrito, adobado_burrito, adobado_plate].

?- find_items(X,[guacamole,cheese,salsa],[]).
X = [al_pastor_taco,combo_plate].
~~~~~
