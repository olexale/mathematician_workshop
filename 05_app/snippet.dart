import 'dart:math';

void main(List<String> arguments) async {
  final repo = WeatherRepository();
  final weather = await repo.getTemperature();
  print('It is $weather degrees in your city!');
}

class WeatherRepository {
  final _api = UnpredictableRealWorldApi();

  Future<double> getTemperature() {
    return _api.getTemperature();
  }
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
