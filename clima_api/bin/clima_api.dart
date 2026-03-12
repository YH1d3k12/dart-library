import '../lib/weather_service.dart';

void main() async {
  final service = WeatherService("59ad705c8d72cd94c9bb6efe1f51efe7");

  double lat = -26.3045;
  double lon = -48.8487;

  print("Buscando clima...");

  try {
    final weather = await service.fetchWeather(lat, lon);

    print("Temperatura: ${weather.temperature} °C");
    print("Clima: ${weather.description}");
  } catch (e) {
    print(e);
  }
}