# Intro 👋

Mathematicians worked with algorithms for much longer than developers. What can you learn from them? Is there something in their approaches that might make sense for a Flutter developer? Let's find out!

This workshop might be interesting for experienced Flutter developers who want to look at familiar problems from an unfamiliar angle.

Authored by **Oleksandr Leushchenko** ([@olexale](https://twitter.com/olexale)). 

# Easy as 2+2 

## Falling apples 🍏

Imagine that each time when you add two to any number, an apple falls from the sky right on your head! 2+2? BAM! An apple! 3+2! BOOM! Another apple! Don't even ask what may fall if you add three or four… It would be so hard to live in this world cause for every action there might be another unexpected unpredictable action. The matematicians call such additional actions _side effects_.

The world is full of unexpected things, so how good it is that abstract math laws are _always_ the same. While you're making some abstract math calculation (like adding two to a number) nothing might go wrong! This operation is predictable, foreseeable, obvious, and completely useless! It's the world that adds meaning. 

For example, a teacher asks a student - "2+2" (that's input operation), the student is doing math in their head and provides an answer (that's output operation). Input and output are unreliable operations, anything might go wrong with them. But not with the math. Math is predictable. 

When developing an app you're simplifying the real world and creating a model for it. It would be perfect to create the "theory of everything" - an algorithm that would describe the app in all possible states, but unfortunately this is hardly achievable. The real world will try to ruin your algorithms and put the app in very unexpected states. What can you do? Keep your code as close by its nature to the math as it's possible and the world will not have a chance!

## Pure math 🤓

Let's get back to the original function:
```dart
num add2(num x) => x + 2;
```

Each time you call it with the same argument, you're getting the same result. This function does not change the environment (i.e. does not modify any static field, non-local variables, etc.). The matematicians call such a function a _pure_ function. What is an impure function then? It's a function that is:
<!-- I was a little surprised add4 is pure yet addK wasn't pure? I would imagine they're both impure since they access global variables? I thought Pure functions only worked with the data that was passed in. I dunno, definitions are hard haha :P -->
* accessing or modifying global or non-local variables; 
* setting a field of an object;
* throwing an exception;
* interacting with the user (by displaying information or reading input);
* reading from or writing to a file;
* drawing on the screen;
* and so on…

Oh wow! This list is huge and it's far from complete! Is it even possible to write any whole app with just pure functions? Long story short - nope, it's not. But! The trick is to create an app core by using pure functions and then add the real-world layer with impure functions. It's like the example from above: the student learns simple arithmetic operations, these operations are both priceless and useless. They are priceless cause they will allow to solve real-world problems, and yet useless on their own. That's the way the matematicians may write apps - by creating some universal math-like knowledge with pure math-like functions, and then adding the real-world interaction layer that will make them useful for real usage. I hope that this workshop will teach you some tricks.

But before we begin, let's double-check that we are aligned on what is a function with a side-effect. Look at these functions in the editor. Which ones are pure? (don't forget to validate yourself)
