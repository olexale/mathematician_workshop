# Refactoring business logic

## Pure functions 🫧

We know which functions are pure and we know how to refactor classes to functions. To make our `Cafe` implementation much more mathematical we just need to combine these topics!

We already have a nice function that produces a function. Are they pure?

> 💡 Writing code as a mathematician means writing a pure core with stateless entities and pure functions, and then, making the code useful by adding a thin layer of side effects on the surface of this core.

Here is the function we had:
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

From that definition we may get another rule:
> 💡 All functions that return `void` are functions with side effects.

> ？Can a function that returns a `Future` be pure? Think about it for a bit, the answer would be at the bottom of the solution.

We already discussed that impure functions are unpredictable at runtime, but maybe there is even more evil in them? Unfortunately, - yes. They are harder to test. For sure, you don't want a real bank transaction to happen each time you run a test suite. The most experienced of us might say "come on, it's not 60th", and will create a `PaymentService` abstract class (an interface) that will have two implementations: a real one and some sort of stub for tests. Developers are so used to stubs/mocks/fakes, so that we don't see the problem with them. But true mathematicians might argue that these entities are not required, and you know what - maybe they are right.

Additionally, we have an issue with reusability. Let's say, a DevOps, a developer, and a mathematician walks into a coffee shop for three cups of coffee. And barista says - "On it! But I will have to prepare them sequentially and in three transactions because our coffee shop has a `getCoffee` implementation that returns only a single cup of coffee." Not ideal. Let's help the cafe and think about how can we create a function that will return N cups. Mathematician wants it to be pure, developer - to avoid code duplication, DevOps - wants to get their coffee at last!

If we copy-paste `getCoffee` function with a new name `getCoffees` and slightly change its implementation, that would lead to code duplication. If we remove the `getCoffee` at all and pretend that it's fine to always return a list of cups that just sounds wrong (you ordered a single cup, so here is your array of coffees, ma'am).

We will try to use the `getCoffee` inside the `getCoffees` function, but before that, we need to make some refactoring. Previously we discussed that mathematicians create a pure core. External dependencies (like a payment system) can not be used in the core. So we need to revisit the function implementation.

## Tuple 🎭

We create a core layer that will provide all the required info to a thin impure layer around the core. In our case, `getCoffee` might return a cup AND all the required information for the payment.

Fortunately, there is a class for that, it is called `Tuple`. Unfortunately, it is not included in the Dart language. So we're going to `pub.dev` for help:
* [`tuple_dart`](https://pub.dev/packages/tuple_dart)
* [`tuple`](https://pub.dev/packages/tuple)

Or you may use one of the more advanced ones:
* [`fpdart`](https://pub.dev/packages/fpdart)
* [`dartz`](https://pub.dev/packages/dartz)

To understand better what it is doing, we will implement our own very primitive version of the `Tuple` class:
```dart
class Tuple<T1, T2> {
  const Tuple(this.first, this.second);
  
  final T1 first;
  final T2 second;
}
```

Cool stuff! Now we need an abstraction over the payment operation, we will call it `Charge`:
```dart
class Charge {
  const Charge(this.cc, this.amount);

  final CreditCard cc;
  final double amount;
}
```

We are ready for the `getCoffee` refactoring now!
```dart
Tuple<Cup, Charge> Function(CreditCard) getCoffeeBuilder() {
  final getCoffee = (cc) {
    final cup = Cup();
    return Tuple(cup, Charge(cc, cup.price)); 
  };
  return getCoffee;
}
```

Look, the `PaymentSystem` dependency just disappeared! We may return `getCoffee` to its initial structure:
```dart
Tuple<Cup, Charge> getCoffee(CreditCard cc) {
  final cup = Cup();
  return Tuple(cup, Charge(cc, cup.price)); 
}
```

Splendid! So, how to get three cups of coffee now?

One of the solutions would be to create a list of cups, get their billing data, and combine that data into a single `Charge` object. For that we may add an additional constructor to `Charge`:
```dart
factory Charge.combined(Charge fitst, Charge second) {
  if (fitst.cc != second.cc) {
    throw Exception('Can not combine charges with different cards');
  }
  return Charge(fitst.cc, fitst.amount + second.amount);
}
```

At last we may implement `getCoffees` and make devops, developer, and mathematician happy:
```dart
Tuple<List<Cup>, Charge> getCoffees(CreditCard cc, int n) {
  final purchases = List<Tuple<Coffee, Charge>>.generate(n, (_) => getCoffee(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases.map((p) => p.second).reduce(Charge.combined),
  );
}
```

DevOps enjoys the coffee, the developer is thinking about tests, but the mathematician is still unhappy! Why? We will try to find out in the next chapter.

Meanwhile, would you please add the possibility to book many rooms for a `Hotel`? (do not forget to check yourself by reviewing the solution)