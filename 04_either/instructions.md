# Charge or Exception

## Impureness spreads 🦠

The problem with `Charge.combined` is in fact, that this constructor does not always build a `Charge` object. If we would try combining bills for different credit cards, we would get an `Exception`. So, the function `Charge.combined` is not pure, which makes all other functions that rely on it not pure (do you hear these "booooo"s from mathematicians?). Unexperienced developers might say that it's not an issue, cause `getCoffees` is implemented in a way that we will never call this constructor with different credit cards. Experienced developers would smile and for the sake of maintainability refactor the code as production-ready code should not contain any surprises.

So, `Charge.combined` returns either `Charge` or `Exception`. Either of them. I think you already got it - there is a special type for that, that is called `Either`.

## Either 🤷

You may get it by adding the following package to your project:
* [`either_dart`](https://pub.dev/packages/either_dart)

Or you may get it from our old friends:
* [`fpdart`](https://pub.dev/packages/fpdart)
* [`dartz`](https://pub.dev/packages/dartz)

To make it more fun, let's create our own version of `Either`! It might look like that:
```dart
abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight);

  Either<U, R> flatMap<U>(Either<U, R> Function(L) f) => fold(
    f, // here f is a short version of (l) => f(l)
    Right.new, // Right.new is the same as (e) => Right(e)
  );
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight) {
    return ifLeft(value);
  }
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight) {
    return ifRight(value);
  }
}
```

Oh wow! So much code! 🐶 There is [a video](https://youtu.be/p9dY-vp7xzY) that describes all the details about Either, you might want to watch it later. Still, let's briefly review what do we have here. An abstract class `Either` , which describes two methods, and two implementations of it - `Left` and `Right`, which are containers for a value. Method `fold` accepts two functions `ifLeft` and `ifRight`. 

By calling `fold` on `Either` one of these functions will be called. If at runtime Either's type is `Left` then `ifLeft` will be called, `Right` - `ifRight`. That allows us to use `Either` type when the exact value type is unknown - it might be either a value in the `Left` container or a value in the `Right`.

A `flatMap` function will combine two `Either` objects. We will see how this can be done in just a moment.

It's time to refactor `Charge.combined` constructor! It can not be a constructor anymore as it will not always construct a `Charge` value now, so it will be a static function:
```dart
static Either<Charge, Exception> combined(
      Either<Charge, Exception> first, 
      Either<Charge, Exception> second,
    ) {
  return first.flatMap((charge) {
    return second.flatMap((charge2) {
      return (charge.cc == charge2.cc)
          ? Left(Charge(charge.cc, charge.amount + charge2.amount))
          : Right(Exception('Can not combine charges with different cards'));
    });
  });
  }
```

> 💡 We had the luxury of returning an `Exception`, but if the `combined` function were a third-party dependency we would need to wrap it inside try..catch block.

Look, this function will always return with a value now! No unpredictable behavior, no surprises, pure math joy. 😌 

Let's use it in `getCoffees`:
```dart
Tuple<List<Cup>, Either<Charge, Exception>> getCoffees(CreditCard cc, int n) {
  final purchases = List<Tuple<Cup, Charge>>.generate(n, (_) => getCoffee(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases
        .map((p) => p.second)
        .map<Either<Charge, Exception>>(Left.new)
        .reduce(Charge.combined),
  );
}
```

The `getCoffees` now return a pair of cups and either a charge or an exception. Let's write a function that creates a bill:
```dart
String composeBill(Tuple<List<Cup>, Either<Charge, Exception>> coffees)
  return coffees.second.fold(
    (c) => 'Total for ${coffees.first.length} cups of coffee: ${c.amount}',
    (e) => 'Ouch! We have an error here: $e',
);
```

This code both adds and reduces the complexity. On small-scale projects the complexity rather increases, so you might not want to add all this math for a simple coffee shop app. On the other hand, if you have an enterprise-level app that must be maintained in the long run, predictability is critical for maintainability.

> 💡 Imagine that the complexity of the app is evaluated in some points from 0 to 10. When you only start the development it is 0, then it increases slowly, in a month that would be 3, in 6 monthes 7, in 2 years - 9 and that's the moment when developers are starting to ask to refactor the app from scratch. With the math approach it is initially 6 (so some devs will say that it's too much for them straight from the beginning), but it will stay 6 in 3 months and in 2 years.

It's your turn again! Fix the `Hotel` sample and let's proceed to the last chapter!