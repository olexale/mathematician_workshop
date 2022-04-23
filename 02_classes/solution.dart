void main(List<String> args) async {
  final myCard = CreditCard();
  final paymentSystem = PaymentSystem();

  final bookRoom = bookRoomBuilder(paymentSystem);
  final room = await bookRoom(myCard);
  print('$room booked!');
}

typedef BookRoomFunction = Future<Room> Function(CreditCard);

BookRoomFunction bookRoomBuilder(PaymentSystem paymentSystem) {
  return (cc) async {
    final room = Room();
    await paymentSystem.charge(cc, room.price);
    return room;
  };
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
