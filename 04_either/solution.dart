void main(List<String> args) async {
  final myCard = CreditCard();
  final paymentSystem = PaymentSystem();

  final rooms = bookRooms(myCard, 3);
  await rooms.second.fold(
    (c) => paymentSystem.charge(c.cc, c.amount),
    (e) => Future.error(e),
  );
  print('${rooms.first.join(', ')} booked!');
}

Tuple<Room, Charge> bookRoom(CreditCard cc) {
  final room = Room();
  return Tuple(room, Charge(cc, room.price));
}

Tuple<List<Room>, Either<Charge, Exception>> bookRooms(CreditCard cc, int n) {
  final purchases = List<Tuple<Room, Charge>>.generate(n, (_) => bookRoom(cc));
  return Tuple(
    purchases.map((p) => p.first).toList(),
    purchases
        .map((p) => p.second)
        .map<Either<Charge, Exception>>(Left.new)
        .reduce(Charge.combined),
  );
}

abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight);

  Either<U, R> flatMap<U>(Either<U, R> Function(L) f) => fold(f, Right.new);
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

class Tuple<T1, T2> {
  const Tuple(this.first, this.second);

  final T1 first;
  final T2 second;
}

class Charge {
  const Charge(this.cc, this.amount);

  static Either<Charge, Exception> combined(
      Either<Charge, Exception> first, Either<Charge, Exception> second) {
    return first.flatMap((charge) {
      return second.flatMap((charge2) {
        return (charge.cc == charge2.cc)
            ? Left(Charge(charge.cc, charge.amount + charge2.amount))
            : Right(Exception('Can not combine charges with different cards'));
      });
    });
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
