void main(List<String> args) async {
  final myCard = CreditCard();
  final paymentSystem = PaymentSystem();

  final rooms = bookRooms(myCard, 3);
  // TOD 4: unwrap the result of the bookRooms invocation and handle an error case
  await paymentSystem.charge(rooms.second.cc, rooms.second.amount);
  print('${rooms.first.join(', ')} booked!');
}

Tuple<Room, Charge> bookRoom(CreditCard cc) {
  final room = Room();
  return Tuple(room, Charge(cc, room.price));
}

// TODO 3: Make this function return Tuple<List<Room>, Either<Charge, Exception>>
Tuple<List<Room>, Charge> bookRooms(CreditCard cc, int n) {
  final purchases = List<Tuple<Room, Charge>>.generate(n, (_) => bookRoom(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases.map((p) => p.second).reduce(Charge.combined),
  );
}

// TODO 1: Add `Either` implementation

class Tuple<T1, T2> {
  const Tuple(this.first, this.second);

  final T1 first;
  final T2 second;
}

class Charge {
  const Charge(this.cc, this.amount);

  // TODO 2: Make this constructor a static function that returns `Either<Charge, Exception>`
  factory Charge.combined(Charge first, Charge second) {
    if (first.cc != second.cc) {
      throw Exception('Can not combine charges with different cards');
    }
    return Charge(first.cc, first.amount + second.amount);
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
