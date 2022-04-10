void main(List<String> args) async {
  final myCard = CreditCard();
  final paymentSystem = PaymentSystem();

  final rooms = bookRooms(myCard, 3);

  // main function is the only function that interacts with the real world now
  await paymentSystem.charge(rooms.second.cc, rooms.second.amount);
  print('${rooms.first.join(', ')} booked!');
}

// An interesting thing happened here: now the function does not return a Future
// That will save you from some mental gymnastics when you write tests.
// Even more interesting is that now you may cache the value.
// Pure functions might be calculated in advance. It's like with 2+2, you
// just know the answer, you don't have to calculate it again.
// For the same `CreditCard` value, after the first `bookRoom` invocation, you can
// return the same value without having to invoke the function again.
Tuple<Room, Charge> bookRoom(CreditCard cc) {
  final room = Room();
  return Tuple(room, Charge(cc, room.price));
}

Tuple<List<Room>, Charge> bookRooms(CreditCard cc, int n) {
  final purchases = List<Tuple<Room, Charge>>.generate(n, (_) => bookRoom(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases.map((p) => p.second).reduce(Charge.combined),
  );
}

class Tuple<T1, T2> {
  const Tuple(this.first, this.second);

  final T1 first;
  final T2 second;
}

class Charge {
  const Charge(this.cc, this.amount);

  factory Charge.combined(Charge fitst, Charge second) {
    if (fitst.cc != second.cc) {
      throw Exception('Can not combine charges with different cards');
    }
    return Charge(fitst.cc, fitst.amount + second.amount);
  }

  final CreditCard cc;
  final double amount;
}

// ---------------- This might come from a third-party library ----------------
class Room {
  Room({this.price = 20});

  final double price;

  @override
  String toString() => 'Room with price $price';
}

class PaymentSystem {
  Future<void> charge(CreditCard cc, double amount) => Future.delayed(
        Duration(milliseconds: 500),
      );
}

class CreditCard {}

// --------------- Can a function that returns Future be pure? ----------------
// TL;DR: No.
// Most of the functions that return Future rely on side-effects: I/O, network,
// database, animations, etc. But even if we ignore that fact, there is still
// one global thing that makes a function that returns Future impure - the event loop.