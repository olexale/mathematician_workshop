# Refactoring business logic

## Pure functions 🫧

We discussed which functions are pure and know how to refactor classes to functions. To make the `Cafe` implementation much more mathematical you just need to combine these topics!

> 💡 Writing code as a mathematician means writing a pure core with stateless entities and pure functions, and then, making the code useful by adding a thin layer of side effects on the surface of this core.

Here is the function from the previous chapter:
```dart
GetCoffeeFunction getCoffeeBuilder(PaymentSystem paymentSystem) {
  final getCoffee = (cc) {
    final cup = Cup();
    paymentSystem.charge(cc, cup.price);
    return cup; 
  };
  return getCoffee;
}
```

The `getCoffeeBuilder` in a nutshell is a function that just creates a local final variable and returns it. The `getCoffee` is a bit more complicated. It is not a pure function because it has a `paymentSystem.charge()` side effect. It interacts with the real world and changes something (here there might be a 3rd party API call, a transaction, database operations, and so on). It's not a function that just returns a cup of coffee, it's unpredictable chaos that scares mathematicians. 😱

> 💡 Here is a rule of thumb: if after removing any line of code in a function the return value does not change, this function has a side effect.

```dart
final getCoffee = (cc) {
  final cup = Cup();
  paymentSystem.charge(cc, cup.price); // this line is "safe" to remove, hence the function is not pure
  return cup;
};
```

From that definition you may get another rule:
> 💡 All functions that return `void` are functions with side effects.

> ？Can a function that returns a `Future` be pure? Think about it for a bit, the answer would be at the bottom of the solution.

Impure functions are unpredictable at runtime, but maybe there is even more evil in them? Unfortunately, - yes. They are harder to test. For sure, you don't want a real bank transaction to happen each time you run a test suite. The most experienced of us might say "come on, haven't you heard about OOP", and will create a `PaymentService` abstract class (an interface) that will have two implementations: a real one and some sort of stub for tests. Developers are so used to stubs/mocks/fakes, so that they don't see the problem with them. But true mathematicians might argue that these entities are not required, and you know what - maybe they are right.

Additionally, there is an issue with reusability. Let's say, a DevOps, a developer, and a mathematician walks into a coffee shop for three cups of coffee. And barista says - "On it! But I will have to prepare them sequentially and in three transactions because our coffee shop has a `getCoffee` implementation that returns only a single cup of coffee." Not ideal. Let's help the cafe and think about how can you create a function that will return N cups. Mathematician wants it to be pure, developer - to avoid code duplication, DevOps - wants to get their coffee at last!

If you copy-paste `getCoffee` function with a new name `getCoffees` and slightly change its implementation, that would lead to code duplication. If you remove the `getCoffee` at all and pretend that it's fine to always return a list of cups that just sounds wrong (you ordered a single cup, so here is your array of coffees, ma'am).

You may use the `getCoffee` inside the `getCoffees` function, but before that, some refactoring is needed. Previously we discussed that mathematicians create a pure core. External dependencies (like a payment system) can not be used in the core. So let's revisit the function implementation.

## Tuple 🎭

When you are writing code as a mathematician, you create a core layer that provides all the required info to a thin impure layer around the core. In our case, `getCoffee` might return a cup AND all the required information for the payment.

Fortunately, there is a class for that, it is called `Tuple`. Unfortunately, it is not included in the Dart language. So, in a real development, you're might get some help from the community:
* [`tuple_dart`](https://pub.dev/packages/tuple_dart)
* [`tuple`](https://pub.dev/packages/tuple)

Or you may use one of the more advanced ones:
* [`fpdart`](https://pub.dev/packages/fpdart)
* [`dartz`](https://pub.dev/packages/dartz)

For simplicity you may use this primitive version of the `Tuple`:
```dart
class Tuple<T1, T2> {
  const Tuple(this.first, this.second);
  
  final T1 first;
  final T2 second;
}
```

> 🛠 Task: Copy `Tuple` implementation to the editor (TODO 1).

Cool stuff! What about an abstraction over the payment operation? Here, let's call it `Charge`:
```dart
class Charge {
  const Charge(this.cc, this.amount);

  final CreditCard cc;
  final double amount;
}
```

> 🛠 Task: Copy `Charge` implementation to the editor (TODO 2).

It's time for the `getCoffee` refactoring now!
```dart
Tuple<Cup, Charge> Function(CreditCard) getCoffeeBuilder() {
  final getCoffee = (cc) {
    final cup = Cup();
    return Tuple(cup, Charge(cc, cup.price)); 
  };
  return getCoffee;
}
```

Look, the `PaymentSystem` dependency just disappeared! You may return `getCoffee` to its initial structure:
```dart
Tuple<Cup, Charge> getCoffee(CreditCard cc) {
  final cup = Cup();
  return Tuple(cup, Charge(cc, cup.price)); 
}
```

> 🛠 Task: Refactor `bookRoomBuilder` to return a `Tuple<Room, Charge>`, the implementation will be similar to `getCoffee`.

Splendid! So, how to get three cups of coffee now?

One of the solutions would be to create a list of cups, get their billing data, and combine that data into a single `Charge` object. For that you may add an additional constructor to `Charge`:
```dart
factory Charge.combined(Charge first, Charge second) {
  if (first.cc != second.cc) {
    // UH OH -- AS I LEARNED IN STEP 1, THIS ISN'T PURE!!! :P
    // Not sure if it matters or is going to be addressed at all going forward, 
    // just some thoughts as I'm working through this step :)
    //
    // Update: It's addressed in the next step. You sly fox.
    throw Exception('Can not combine charges with different cards');
  }
  return Charge(first.cc, first.amount + second.amount);
}
```

> 🛠 Task: Add this constructor to the `Charge` class (TODO 4).

At last you may implement `getCoffees` and make devops, developer, and mathematician happy:
```dart
Tuple<List<Cup>, Charge> getCoffees(CreditCard cc, int n) {
  final purchases = List<Tuple<Coffee, Charge>>.generate(n, (_) => getCoffee(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases.map((p) => p.second).reduce(Charge.combined),
  );
}
```

> 🛠 Task: Implement a similar function `bookRooms` with return value `Tuple<List<Room>, Charge>`. (TODO 5)

DevOps enjoys the coffee, the developer is thinking about tests, but the mathematician is still unhappy! Why? Let's find out in the next chapter.

> 🛠 Task: Meanwhile, would you book 3 rooms for these folks? (TODO 6) Don't forget to charge them via `PaymentSystem`. (check the implementation by reviewing the solution when you're done)