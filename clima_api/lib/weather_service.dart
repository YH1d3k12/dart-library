import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pt_br");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception("Erro HTTP: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erro ao buscar clima: $e");
    }
  }
}