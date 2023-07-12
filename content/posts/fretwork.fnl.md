---
title: "Fretwork.fnl"
date: 2023-07-12T11:31:53-07:00
draft: false
image: /fretwork.jpg
description: Fennel is a powerful Lisp syntax for the Lua language. I'm becoming increasingly obsessed with it, but the tooling is immature. This post discusses a desire to build a tiny and novel utility that helps developers package and distribute their Fennel code in a variety of different ways.
---

- [x] Is This a Draft?

> Advisory, these thoughts are my own and are not affiliated with the core Fennel team in any way. I am not an active contributor to the language spec, just a lowly hacker.

{{< figure src=https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Lisp_logo.svg/1200px-Lisp_logo.svg.png width=200 >}}

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Lisp_logo.svg/1200px-Lisp_logo.svg.png"/>

# Introduction
[Fennel](https://fennel-lang.org) is an awesome language. It's serving as my first introduction in actually using and engaging with the Lisp paradigm instead of just engaging with the ideas conceptually. Because it is a _superset of the Lua language_, Fennel comes with many things straight out of the box, including the ability to import and run _any existing Lua libraries_, as well as the ability easily embed your Fennel code (similar to the ease of Lua).

If you're looking to learn more about Fennel, check out [fennel-lang.org](https://fennel-lang.org/) which contains a setup guide, tutorial, rationale, API references, and much more. This article assumes at least a basic understanding of programming in general, while specifics regarding Fennel, and the lifecycle of Lua executables and libraries (in this case, LuaRocks / rockspecs) will be explained briefly before diving deeper on the dream for better Fennel tooling.

# Context: _Lua_
It's important for me to introduce some context before I begin discussing what I would like to see in terms of better Fennel tooling. The reason I became attracted to Fennel in the first place was that it is a superset of Lua. The _Lua language_ is incredibly underrated and powerful; It's incredibly small in implementation size (< 63kb), which allows the interpreter to be easily embedded into other programs. This small implementation size says something even greater about Lua. It's a tiny syntax, and small core library. In fact, there is only one core data structure: the [table](https://www.lua.org/pil/2.5.html). For other developers who have never read or written Lua code, this may come as a shock, but it to me is one of Lua's greatest features: It _only_ comes with the things you _absolutely_ need. Due to it's small syntax, any intermediate developer coming from another language could pick up the basics of Lua in less than a hour, and the hurdle from a "_hello world_"to a full application feels much smaller than many other languages (on par with Python imo).

### Why I Started Using Lua
> Ok, ok. I get it, Lua is great. But what are you using it for?

Day-to-day, I use Lua to configure two of my core components driving my GNU/Linux system: _Neovim_ and _AwesomeWM_, and I'm excited to use it in the future for bigger projects that stand on their own. Lua seems to carry with it a philosophy of reprogrammability, i.e., programs should be easy for the end user to reprogram themselves. This aligns deeply with my own core philosophies regarding free software, and Lua makes it easy in it's simplicity.

### Why Fennel
Much of the reasoning behind why I'm so intrigued by Fennel can be found in the [Rationale](https://fennel-lang.org/rationale) section on it's website. Additionally, for me, it's the added draw of being my first Lisp. I think if I started with something like Clojure I'd still be getting up to speed on understanding the runtime (I don't know Java, I know C), whereas Fennel allows me to jump in immediately, since it only requires you understand Lua; And Lua is as simple as they come.

When I actually started my Fennel journey I, admittely, barely knew Lua. I sort of learned the two at the same time by reverse engineering large pre-built configurations like [NvChad](https://nvchad.com) and porting smaller components into Fennel. What I began to realize, and what every Lisp developer already knows, is how powerful the syntax is for reducing repetitive code. Alongside the act of carrying a strong attitude towards readability and away from common pitfalls other languages usually _contain_, Fennel feels like the perfect language to write projects in that are to be made easily reprogrammable by an end user.

# Context: _Tooling_

# Fretwork.fnl
