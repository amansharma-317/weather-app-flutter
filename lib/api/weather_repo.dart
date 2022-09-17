import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/api/weather_model.dart';


  Future<Welcome> getWeather(double lat, double lon) async {
    final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=ef60d290fbdac11e8c55af4386e4e771'));

    if(result.statusCode != 200) {
      throw Exception();
    } else {
      final jsonDecoded = Welcome.fromJson(jsonDecode(result.body));
      return jsonDecoded;
    }
  }

Future<Welcome> getWeatherFromCity(String city) async {
  final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=ef60d290fbdac11e8c55af4386e4e771'));

  if(result.statusCode != 200) {
    throw Exception();
  } else {
    final jsonDecoded = Welcome.fromJson(jsonDecode(result.body));
    return jsonDecoded;
  }
}





