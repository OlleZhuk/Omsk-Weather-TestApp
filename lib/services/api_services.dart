import 'dart:convert';
import 'package:http/http.dart';

import '../models/weather_data.dart';
import 'snack_bar_service.dart';

Future fetchWeatherInfo(city) async {
  try {
    String apiKey = "97de2580d35e4e48826130548250801";
    Response response = await get(Uri.parse(
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&lang=ru',
      // 'https://api.weatherapi.com/v1/current.json?key=2ba0a3b4a93643e8a3b232706241212&q=omsk&lang=ru',
      // 'https://api.weatherapi.com/v1/forecast.json?key=2ba0a3b4a93643e8a3b232706241212&q=omsk&lang=ru&days=1',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes)); //+корректировка рус.символов
      String name = data["location"]["name"]; //город
      //
      int temperature = (data["current"]["temp_c"]).ceil(); //Т на этот час
      int temperatureFL = (data["current"]["feelslike_c"]).ceil(); //Т ощущается
      //
      String conditions =
          data["current"]["condition"]["text"]; //погодные условия (ПУ)
      String imagePath = data["current"]["condition"]["icon"]; //картинка для ПУ
      //
      int windSpeed = (data["current"]["wind_kph"] * 10 / 36).ceil(); //ветер
      int windGusts = (data["current"]["gust_kph"] * 10 / 36).ceil(); //порывы
      //
      int humidity = data["current"]["humidity"]; //влажность
      double pressure =
          (data["current"]["pressure_mb"]) * .751; //давление мм рт ст
      String updateTime = data["current"]["last_updated"]; //время обновленния

      return WeatherData(
        name: name,
        time: updateTime,
        temperature: temperature,
        temperatureFL: temperatureFL,
        conditions: conditions,
        imagePath: imagePath,
        windSpeed: windSpeed,
        windGusts: windGusts,
        humidity: humidity,
        pressure: pressure,
      );
    }
  } catch (e) {
    SnackBarService.showSnackBar(content: '$e');
  }
}
