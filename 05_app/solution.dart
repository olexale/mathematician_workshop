import 'dart:math';

void main(List<String> arguments) async {
  final api = UnpredictableRealWorldApi();
  final getTemperature = getTemperatureReader(api);
  final weather = await getTemperature();
  print(
    weather.fold(
      (t) => 'It is $t degrees in your city!',
      (e) => 'Error: $e',
    ),
  );
}

Future<Either<double, Object>> Function() getTemperatureReader(
  UnpredictableRealWorldApi api,
) {
  return () => api.getTemperature().then<Either<double, Object>>(
        Left.new, // Left.new is the same as (v) => Left(v)
        onError: (e) => Right<double, Object>(e),
      );
}

// In real life this class is supposed to be imported from any of these packages:
// * https://pub.dev/packages/either_dart
// * https://pub.dev/packages/fpdart
// * https://pub.dev/packages/dartz
abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight);
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight) => ifLeft(value);
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  B fold<B>(B Function(L) ifLeft, B Function(R) ifRight) => ifRight(value);
}

// ---------------------- DO NOT CHANGE THAT ----------------------
// Let's pretend that this code is in third-party library and can not be changed
class UnpredictableRealWorldApi {
  final _rnd = Random();

  Future<double> getTemperature() {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        final temperature = _rnd.nextDouble() * 40;
        if (temperature > 20 && temperature < 25) {
          throw Exception('Too good to be true!');
        }
        return temperature;
      },
    );
  }
}
