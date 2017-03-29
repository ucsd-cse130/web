---
title: How to run Prolog in the Lab machines
headerImg: books.jpg
---


## Entering the Prolog Shell

Here is a sample session. We use `$` for the Unix shell prompt, and `?-` for
the Prolog shell prompt.

~~~~~{.prolog}
$ rlwrap swipl

130f@ieng6-202]:~:501$ swipl
Welcome to SWI-Prolog (Multi-threaded, 32 bits, Version 5.10.5)
Copyright (c) 1990-2011 University of Amsterdam, VU Amsterdam
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software,
and you are welcome to redistribute it under certain conditions.
Please visit http://www.swi-prolog.org for details.

For help, use ?- help(Topic). or ?- apropos(Word).

?- X = cat.
X = cat.

?- X = Y.
X = Y.

?- halt.
~~~~~

To **load** a program [lec-prolog.pl](/lectures/lec-prolog.pl)  from disk use the `consult` command like so:

~~~~~{.prolog}
?- consult('lec-prolog.pl').
% foo.pl compiled 0.00 sec, 10,640 bytes
true.

?- parent(albert, z).
false.

?- parent(albert, Z).
Z = felix ;
Z = dana.

?- parent(Z, dana).
Z = albert ;
false.
~~~~~
