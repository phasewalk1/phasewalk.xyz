---
title: "(DRAFT) Functional Programming, Lisp, and The Lambda Calculus"
date: 2023-06-16T13:27:22-07:00
draft: false
math: true
description: "A relic of the old guard? Or the paradigm of the future?"
---

{{< math.inline >}}
{{ if or .Page.Params.math .Site.Params.math }}
<!-- KaTeX -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/katex.min.css" integrity="sha384-dbVIfZGuN1Yq7/1Ocstc1lUEm+AT+/rCkibIcC/OmWo5f0EA48Vf8CytHzGrSwbQ" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/katex.min.js" integrity="sha384-2BKqo+exmr9su6dir+qCw08N2ZKRucY4PrGQPPWU1A7FtlCGjmEGFqXCv5nyM5Ij" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.10.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>
{{ end }}
{{</ math.inline >}}

## Overview
Different programming paradigms have emerged over the years to address various challenges and improve software development practices. This emergence and subsequent adoption of new paradigms has been agnostic to the level of abstraction at which specific groups of programmers reside--whether you're programming embedded on _bare metal_ or a dynamic, type-safe API to run in a container--these new paradigms have touched every field of software. From procedural programming to object-oriented programming, each approach brings its own unique focus, while also carrying with it some identifiably similar, smaller chunks from other paradigms. The paradigm of functional programming is arguably one of the first programming paradigms devised to aptly model computation by way of _function application_, and although some see it as a relic of the old guard, there are many reasons why us as programmers should still care about it.

## Functional Programming
Functional programming is a programming paradigm that emphasizes the use of _pure functions_ and _immutable data_. Unlike imperative programming, which focuses on executing a series of statements and modifying state, functional programming _treats computation as the evaluation of mathematical functions_. It encourages writing code in a _declarative_ manner, in which functions are defined to convert input data into an output without mutating its input. 

Functional programming stands on top of a mathematical framework for modeling computation, which was developed by [Alonzo Church](https://en.wikipedia.org/wiki/Alonzo_Church) in the 1930s and known as, _The Lambda Calculus_.

>> In 1937 [Alan Turing](https://en.wikipedia.org/wiki/Alan_Turing "Alan Turing") proved that the lambda calculus and [Turing machines](https://en.wikipedia.org/wiki/Turing_machines "Turing machines") are equivalent models of computation, showing that the lambda calculus is [Turing complete](https://en.wikipedia.org/wiki/Turing_complete "Turing complete"). Lambda calculus forms the basis of all functional programming languages.
>> [Functional Programming Wiki](https://en.wikipedia.org/wiki/Functional_programming)

## Why Functional Programming?
There are many benefits to the paradigm of functional programming. _Pure functions_ (a building block of a functional program) are inherently ***thread-safe*** and independent of the execution context (data is immutable). This allows purely functional programs to facilitate parallelism and concurrent programming with much less headaches than many other, more modern paradigms, in which you sometimes have to engineer a way into making your structures thread-safe.

Another benefit of functional programming is the readability of code. Although Lisp and all it's parentheses have become a meme in the world of modern software, I believe that every developer should learn to write Lisp code. It gives so much insight into how modern languages, interpreters, and compilers make sense of more modern, feature-rich languages. And it does all this directly in front of you--no magic.

## The Lambda Calculus
_The Lambda Calculus_ is a formal mathematical system developed in the 1930s to serve as a foundation for studying computation and computability and was later extended to serve as the theoretical basis for functional programming languages. The Lambda Calculus provides a simple yet powerful framework for expressing computations in terms of pure functions.

In the Lambda Calculus, functions are defined using _lambda expressions_. Lambda expressions consist of parameters, a body, and the $\lambda$ symbol. Here's a simple lambda expression that takes one parameter, $x$ and simply returns itself.

$$
\lambda x.x
$$


This same function could be written in a procedural paradigm, as:
```C++
int doNothing(int x) { return x; }
```

Of course, lambda expressions can do much more than just return their arguments. In fact, lambda expressions are Turing Complete--they can do *everything*.

Let's modify the example expression above. Say we want to implement a _squaring_ function that accepts an $x$ and returns $x^2$. Simple enough, we can follow the same syntax as above and define our function as so:
$$
\lambda x.x*x
$$

Now that we've scratched the surface of functional programming, and The Lambda Calculus, let's talk about Lisp.

<h2>Programming in Lisp</h2>
A programmer sees the following code and suddenly, feels uneasy.
```Lisp
(* (+ 2 (* 4 6))
 (+ 3 5 7))
```
That's fair. The first time I interacted with Lisp code I felt like it was time to go outside: I've seen enough! It wasn't until about a half-an-hour into my journey did the mystery begin to unravel itself into a beautiful tree of recursion.

The block of code above uses the concept of _combinations_ to recursively evaluate the lambda expression. This recursive evaluation uses the concept of substitution (_Beta Reduction_) to compute the output, and it's flow can be modeled by a tree:

{{< figure src="/Expression.png" >}}
