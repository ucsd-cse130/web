---
title: Hello, world!
headerImg: sea.jpg
date: 2017-03-28
---

<br>
<br>
<br>
<br>
<br>
<br>

## A Programming Language

### Two Variables

- `x`, `y`

### Three Operations

- `x++`
- `x--`
- `x = 0 ? L1 : L2`

### Example Program

(What _does_ it do?)

```
L1: x++
    y--
    y = 0 ? L2 : L1
L2: ...
```

**Fact** The above language is _equivalent to_ every PL!

- But good luck writing QuickSort ...
- ... or Plants v. Zombies
- ... or Spotify!

<br>
<br>
<br>
<br>
<br>
<br>

## So Why Study Programming Languages?

![Federico Fellini](/static/img/fellini.png){#fig:fellini .align-center width=50%}

> A different language
> is
> a different vision
> of life.


<br>
<br>
<br>
<br>
<br>
<br>

## So Why Study Programming Languages?

> The principle of **linguistic relativity**
> holds that the structure of a language
> affects its speakers world view or cognition.

Or more simply:

> Programming Language
> shapes
> Programming Thought.

Language affects how:

- **Ideas** are expressed
- **Computation** is expressed

![No spoilers here](/static/img/arrival-symbol.jpg){#fig:arrival .align-center width=50%}



<br>
<br>
<br>
<br>
<br>
<br>



## Course Goals

![Morpheus, The Matrix](/static/img/morpheus.png){#fig:morpheus .align-center width=50%}

> Free Your Mind.



<br>
<br>
<br>
<br>
<br>
<br>


## Goal: Learn New Languages / Constructs

![Musical Score](/static/img/music-score.png){#fig:music .align-center width=50%}

New ways to **describe** and **organize** computation,

To create programs that are:

- **Readable**
- **Correct**
- **Extendable**
- **Modifiable**
- **Reusable**



<br>
<br>
<br>
<br>
<br>
<br>


## New languages come (and go ...)

There was no

* Java 20 years ago,
* C#   15 years ago,
* Rust 10 years ago,
* Go   5  years ago...



<br>
<br>
<br>
<br>
<br>
<br>

## Goal: Learn to Learn

In 130 you will learn the **anatomy** of a PL

- Fundamental **building blocks**
- Different guises in different PLs

Help to better understand the PLs you already "know".

![Anatomy](/static/img/anatomy.png){#fig:anatomy .align-center width=50%}



<br>
<br>
<br>
<br>
<br>
<br>

## Goal: How to Design new Languages

Buried in **every extensible** system is a PL

- Emacs, Android: LISP
- Word, Powerpoint: Macros, VBScript
- Firefox, Chrome, Safari: JavaScript
- SQL, Renderman, Latex, XML ...

If **you** work on a large system, you **will** design a new PL!



<br>
<br>
<br>
<br>
<br>
<br>

## Goal: Enable You To Choose Right PL

But isn't that decided by

- Libraries
- Standards
- Hiring
- Your Boss?!

Yes.

**My goal:** Educate tomorrow's leaders so you'll make **informed** choices.



<br>
<br>
<br>
<br>
<br>
<br>

## Speaking of Right and Wrong

![x = x + 1](/static/img/wtf-x-plus-one.png)



<br>
<br>
<br>
<br>
<br>
<br>

## Imperative Programming is Wrong (default)

![Gears of War](/static/img/unreal.png){#fig:sweeney .align-center width=70%}

Tim Sweeney (Epic, Creator of the UNREAL Gaming Engine)

> In a concurrent world,
> imperative is the wrong default.





<br>
<br>
<br>
<br>
<br>
<br>

## Imperative Programming is Wrong (default)

John Carmack, creator of FPS (Doom, Quake, ...)

![Carmack discourages variable mutation](/static/img/carmack-tweet.png){#fig:carmack .align-center width=70%}



<br>
<br>
<br>
<br>
<br>
<br>

## Functional Programming

- No assignment
- No mutation
- No loops



<br>
<br>
<br>
<br>
<br>
<br>

## OMG! Who uses FP?!

- Google    (MapReduce, ...)
- Microsoft (LinQ, F#, ...)
- Facebook  (Erlang, Reason,...)
- Twitter   (Scala, ...)
- Wall St.  (Haskell, Ocaml, ...)

and, most importantly ....

- **CSE 130**

## Course Mechanics: Web Page

All information lives online:

- [github](https://github.com/ucsd-cse130/web)
- [webpage](http://ucsd-cse130.github.io/)
- [piazza](https://piazza.com/ucsd/spring2017/cse130/home)



<br>
<br>
<br>
<br>
<br>
<br>

## Course Mechanics: Clickers

Make class interactive

+ Help **you** and **me** understand whats tricky

Clickers Are Not Optional

+  **Cheap** ones are fine
+  **Respond** to 75% questions
+  **Worth** 5% of your grade

Laptops are welcome in lecture (but optional)



<br>
<br>
<br>
<br>
<br>
<br>

## Course Mechanics: In Class Exercises

1. **Solo Vote**
  - Think for yourself, select answer

2. **Discuss**
  - Analyze Problem in Groups
  - Reach consensus
  - Have questions, raise your hand!

3. **Group Vote**
  - Everyone in group votes
  - Must have same vote to get points

4. **Class Discuss**
  - What was easy or tricky?



<br>
<br>
<br>
<br>
<br>
<br>

## Course Mechanics: Grading

**(30%) Assignments**

+ 6-7 assignments
+ All programming

**(30%) Midterm**

+ In-class (TBA)
+ 2-sided printed "cheat sheet"

**(35%) Final**

+ 2-sided printed cheat sheet

**(05%) Clickers**

+ *Attempting to answer* > 75% questions

**(05%) Piazza Extra Credit**

+ To **top 20** best participants



<br>
<br>
<br>
<br>
<br>
<br>

## Course Mechanics: Grading

**CSE 130 is graded on a curve**

- Lots of work
- Don't worry (too much) about grade



<br>
<br>
<br>
<br>
<br>
<br>

## Course Mechanics: No Text

- Online lecture notes and links

- **Pay attention to lecture**

- **Do Assignments Yourself**



<br>
<br>
<br>
<br>
<br>
<br>

## Programming Assignments

- About 6-7 over the quarter

- Accessed via `github`

- Schedule up on webpage (due Fridays 5 PM)



<br>
<br>
<br>
<br>
<br>
<br>

## Programming Assignments

![Don't complain](
http://core0.staticworld.net/images/article/2015/09/frustrated_developer-100614973-gallery.idge.jpg)



<br>
<br>
<br>
<br>
<br>
<br>

## Programming Assignments

Unfamiliar **Languages** and **Environments**
**Forget**

- Java, C, C++ ...
- ... and other 20th century languages

**Don't Complain**

- That X-language is hard
- That X-language is @!%$#$

**Do**

- Start early
- Ask lots of questions!



<br>
<br>
<br>
<br>
<br>
<br>

## Programming Assignments

No Deadline Extension

- Four **late days**, used as **whole unit**
- 5 mins late = 1 late day
- *Plan ahead* no other extensions



<br>
<br>
<br>
<br>
<br>
<br>

## A Word from Our Sponsor

Programming Assignments done **alone**

  - Zero Tolerance
  - Offenders punished ruthlessly
  - Please see academic integrity statement

We use **plagiarism detection** software

  - I am an expert
  - Have code from all previous classes
  - MOSS is fantastic, plagiarize at your own risk



<br>
<br>
<br>
<br>
<br>
<br>


## Plan

**FP**

- Haskell
- 5 weeks

**OO**

- Scala
- 3 weeks

**Logic**

- Prolog
- 2 weeks



<br>
<br>
<br>
<br>
<br>
<br>

## **QuickSort** in C

```c
void sort(int arr[], int beg, int end){
  if (end > beg + 1){
    int piv = arr[beg];
    int l = beg + 1;
    int r = end;
    while (l != r-1)
       if(arr[l] <= piv) l++;
       else swap(&arr[l], &arr[r--]);
    if(arr[l]<=piv && arr[r]<=piv)
       l=r+1;
    else if(arr[l]<=piv && arr[r]>piv)
       {l++; r--;}
    else if (arr[l]>piv && arr[r]<=piv)
       swap(&arr[l++], &arr[r--]);
    else r=l-1;
    swap(&arr[r--], &arr[beg]);
    sort(arr, beg, r);
    sort(arr, l, end);
  }
}
```



<br>
<br>
<br>
<br>
<br>
<br>

## **QuickSort** in Haskell

```Haskell
sort []     = []
sort (x:xs) = sort ls ++ [x] ++ sort rs
  where
    ls      = [ l | l <- xs, l <= x ]
    rs      = [ r | r <- xs, x <  r ]
```

(not a wholly [fair comparison...](http://stackoverflow.com/questions/7717691/why-is-the-minimalist-example-haskell-quicksort-not-a-true-quicksort))



<br>
<br>
<br>
<br>
<br>
<br>

## Readability Matters ...



<br>
<br>
<br>
<br>
<br>
<br>

## QuickSort in `J`

```j
sort =: (($:@(<#[),(=#[),$:@(>#[))({~ ?@#))^: (1:<#)
```



<br>
<br>
<br>
<br>
<br>
<br>

## Plan for next 5 weeks

- **Tiny core** language (Lambda Calculus)

- **Fast forward** intro to Haskell

- **Rewind** and go over anatomy individually



<br>
<br>
<br>
<br>
<br>
<br>
