---
title: How to run Ocaml in the Lab machines
headerImg: books.jpg
---

## Entering the Ocaml Shell

You need to type `prep cs130s` before you can run `Ocaml`.

Here is a sample session.

```bash
$ prep cs130s

$ ocaml
        OCaml version 4.02.3

# 2 + 3;;
- : int = 5

# Printf.printf "Hello, %s \n" "world" ;;
Hello, world
- : unit = ()
```

If you run `Ocaml` on your _own_ machine, then do 

```bash
$ rlwrap ocaml
```

The `rlwrap` is **optional** but rather nice as it lets you
hit the up/down cursors to go to your old commands (to avoid
typing them out again.) We have used `alias` so you don't have
to type it out on `ieng6`.


## Loading Files

Enter

```ocaml
#use "foo.ml";;
```

to `load` the file `foo.ml`.
This has the same effect as
typing out the file at the
prompt, but its usually more
convenient to type and edit
the file with Vim/Emacs/Atom
and load it in like this.
(A more convenient option is
the OCaml-mode for Emacs.)

Press `Ctrl-D` to exit OCaml.

## Directly Running Ocaml from Bash

You can directly _run_ the file,
i.e. send the file `foo.ml` into
OCaml and get the output piped
to `stdout` by typing:

```bash
$ ocaml foo.ml
```
