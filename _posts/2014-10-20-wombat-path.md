---
layout: post
title:  "Wombat Path"
author: gtalent
date:   2014-10-20
categories: devlog
---

In this post, we will cover a crucial element of *wombat*'s desgin, the Wombat Path. The path is a core idea behind how *wombat* handles its game data and game save data. The path has a very simple design with a short description, but no one can understand the inner-workings of *wombat* without understanding this construct.

### The Problem
Like any piece of software that wants to preserve some state data for the next time it runs, *wombat* needs to be able to store and retrieve certain data it cares about accessing later. For *wombat*, this includes things like game saves, creature definitions, world layout, and a good deal more. Different software will do this in different ways, but *wombat* does this by represent serializing data structures to the disk in a more or less one to one format.

One of the challenges here is handling static game data differently from game save data. We could look at a variety of examples, but say that a default NPC needs to change over the course of the game. We need to store this change, but we don't want to alter the original. So how do we resolve this? One solution would be to set up two categories of data, one for static files, and another for game save files. That could work, but it would leave us with data shifting from one category to another as requirements change. This solution also introduces certain difficulties to updating the static game data, but we'll touch more on that later.

### The Path
The solution that *wombat* has chosen to go pull from a feature of modern operating systems, namely the idea of a PATH. On both Unix-like systems and on systems of DOS heritage, the system has an environment variable named PATH. The path variable stores a list a of directories for the system to search through when the user wants to execute a command. The system will iterate over the list until it finds a directory with the requested command, and then run it. While *wombat* does not have a use for a path variable in this sense, it can borrow the concept.

*wombat* will has a list of directories to read data from. Typically this list will consist of only two elements, but it would have more.
A typical configuration will have two directories in the path:

* Static Files Directory
* Game Save Directory

When *wombat* seeks a file, it will first check the game save directory, and then the static files directory. Then, when *wombat* goes to write data out, it will only ever write to the last directory in the list, namely the game save directory. This gives an abstract picture of a unified collection of files without redundancies.

### Updating and Moddding
As noted earlier, this model also has an advantages in updating static files. Say for example we have a region in game called *Lake Grundie*, which also happens to be where the user was when they last exited the game. We want the user to find the current region the same as it was when they exited the game, so we save a copy of the modified version of the region in the game save directory, and then that will get deleted when the user exits that region. Now, let's also say that *Lake Grundie* happens to have received an update since the user last exited the game, and that update gets applied to the version in the static files directory. So now, when the user comes back, the old version in the game save directory will get loaded to allow the user to pick up where they left off, but once the user leaves the region and comes back, they will appear in the new one.

Of course this does not eliminate all problems. If the old version of the region exited to a region that no longer exits, of course that would cause problem, but changes to existing regions need not be lost just because they received an update. Finally, by adding a middle directory to the path, we have a place to install mods. This middle directory provides a second static files directory place to install mods, without having to overwrite the vanilla content.
