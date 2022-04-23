void main(List<String> args) async {
  final myCard = CreditCard();
  final paymentSystem = PaymentSystem();

  // TODO 6: Book 3 rooms
  final bookRoom = bookRoomBuilder(paymentSystem);
  final room = await bookRoom(myCard);
  print('$room booked!');
}

typedef BookRoomFunction = Future<Room> Function(CreditCard);

// TODO 3: Refactor `bookRoomBuilder` to return a Tuple<Room, Charge>
BookRoomFunction bookRoomBuilder(PaymentSystem paymentSystem) {
  return (cc) async {
    final room = Room();
    await paymentSystem.charge(cc, room.price);
    return room;
  };
}

// TODO 5: Add `bookRooms` function that takes a CreditCard and a number of rooms to be booked

// TODO 1: Add `Tuple` implementation

// TODO 2: Add `Charge` implementation
// TODO 4: Add `Charge.combined` constructor

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
