# Classes vs functions

## Let's talk about classes 🧱

Classes:
* have some variable fields, that might be modified;
* have final fields, that will not be modified;
* have constructors that initialize the fields;
* have methods that can be called to perform some actions, like making calculations and interacting with other classes;

Classes, unless used as method-holders only, tend to have a stateful behavior. How to resist that tension? By explicitly using functions instead of classes! But is it even possible to code the business logic by using functions only? You bet!

## Coffee shop ☕️

Let's take this class as an example:
```dart
class Cafe {
  Cafe(this.paymentSystem);
  final PaymentSystem paymentSystem;

  Cup getCoffee(CreditCard cc) {
    final cup = Cup();
    paymentSystem.charge(cc, cup.price);
    return cup;
  }
}
```

That looks like a regular cafe to me, with a payment system, and a possibility to grab a cup of nice coffee (I know that many devs in the community prefer tea, so you may change `getCoffee` to `getTea` if you'd like).

Is it possible to transform this class to a function? Well, there is only one method here, so if you move the `PaymentSystem` dependency into the function parameter, you can get rid of the class! The function will look like this:
```dart
Cup getCoffee(PaymentSystem paymentSystem, CreditCard cc) {
  final cup = Cup();
  paymentSystem.charge(cc, cup.price);
  return cup; 
}
```

Done and done! 🎉 

But wait, there is something I don't really like here. Before it was obvious that in order for cafe to work it required a payment system. And when a visitor wanted a cup of coffee all that was required was a credit card. Now, when all the parameters are sent simultaneously, it looks like the visitor needs to come with their own payment system and a credit card. That looks wrong. How to fix that?

Do you remember "Inception" movie with Leonardo DiCaprio? To fix their real-life problems characters created a reality inside a reality. Just like them, let's "go deeper" and instead of a function that returns a value, create a function that returns a function that returns a value. The mathematicians call that [currying](https://en.wikipedia.org/wiki/Currying). It might look wild at first glance, but mathematicians got used to it.

So, you may create a function that expects all required dependencies (like a constructor in a class, in our case the dependency would be a `PaymentSystem` class) which will produce a function that will accept a credit card and return a cup of coffee:
```dart
typedef GetCoffeeFunction = Cup Function(CreditCard);

GetCoffeeFunction getCoffeeBuilder(PaymentSystem paymentSystem) {
  final getCoffee = (cc) {
    final cup = Cup()
    paymentSystem.charge(cc, cup.price);
    return cup; 
  };
  return getCoffee;
}
```

How to use that you may ask? Here is the old and the new usage samples:
```dart
// Old class usage
final cafe = Cafe(PaymentSystem());
final cup = cafe.getCoffee(creditCard);

// New functional usage
final getCoffee = getCoffeeBuilder(PaymentSystem());
final cup = getCoffee(creditCard);
```

Not so many things have changed, right? Is this code written in a math style? Not yet.

That's just the beginning. Writing code as a mathematician does not mean just replacing all classes with functions. Look closely at the `getCoffee` function. By calling `paymentSystem.charge()` you have the same situation as when you're being bombarded by apples by adding 2 to any number. What this `paymentSystem` is really doing? Will it charge a credit card? Will it throw an `Exception`? No idea. Not having control over the logic flow is the opposite of the "mathematical style"™️. We will make the code better in the next chapter. 

> 🛠 Task: In the editor, there is a task for you. Refactor the `Hotel` class into a function. Notice that it is a bit different from the one that's described here. It's slightly more complicated which is a bit more fun.