import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/app_colors.dart';
import '../services/api_services.dart';
import '../models/weather_data.dart';
import '../services/snack_bar_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherData? _weatherData;
  final _changeLocationController = TextEditingController();
  late Future<void> _getWeather;

  @override
  void initState() {
    _getWeather = fetchWeatherInfo("омск").then((data) {
      setState(() => _weatherData = data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateFormat dateFormat = DateFormat('EE, d MMMM y', 'ru');
    String formattedDate = dateFormat.format(currentDate);

    return FutureBuilder(
      future: _getWeather,
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ))
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 80,

                // поиск городов
                title: SearchBar(
                  controller: _changeLocationController,
                  leading: const Icon(Icons.search),
                  hintText: 'Город',
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),

                    // кнопка подтверждения поиска
                    child: TextButton(
                      onPressed: () async {
                        try {
                          WeatherData newWeatherData = await fetchWeatherInfo(
                              _changeLocationController.text);
                          _changeLocationController.clear();
                          setState(() {
                            _weatherData = newWeatherData;
                            FocusScope.of(context).unfocus();
                          });
                        } catch (e) {
                          SnackBarService.showSnackBar(
                              content: 'Город не найден. Попробуйте еще раз!');
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(
                              color: AppColors.secondMainColor),
                        ),
                      ),
                      child: _buttnTxt('Найти'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),

                    // кнопка сброса в исходное
                    child: TextButton(
                      onPressed: () async {
                        WeatherData newWeatherData =
                            await fetchWeatherInfo('Омск');
                        setState(() => _weatherData = newWeatherData);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(color: AppColors.mainColor),
                        ),
                      ),
                      child: _buttnTxt('Омск'),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Дата
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: AppColors.backgroundColor,
                            ),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                color: AppColors.secondMainColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Время обновления: ${_weatherData!.time.replaceRange(0, 11, '')}',
                        ),
                        const SizedBox(height: 30),

                        // Название города
                        Text(_weatherData!.name,
                            style: const TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            )),

                        //Погодные условия (ПУ)
                        Text(
                          _weatherData!.conditions,
                          style: TextStyle(
                            color: AppColors.mainColor.withOpacity(.7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Температура
                        Text(
                          "${_weatherData?.temperature}°",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 100,
                          ),
                        ),

                        // Картинка + другие ПУ
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Картинка
                              Image.network(
                                (_weatherData!.imagePath).replaceFirst('',
                                    'https:'), //подстановка недостающего https:
                                scale: .7,
                              ),

                              // Разделитель
                              _vertDivider(),

                              // Другие ПУ
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Ощущается, как ${_weatherData?.temperatureFL}°'),
                                  Text(
                                      'Ветер: ${_weatherData?.windSpeed}...${_weatherData?.windGusts} м/с'),
                                  Text('Влажность: ${_weatherData?.humidity}%'),
                                  Text(
                                      'Давление: ${_weatherData?.pressure.ceil()} мм рт.ст.'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

Widget _vertDivider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 80,
        width: 1,
        color: AppColors.mainColor,
      ),
    );

Widget _buttnTxt(String text) => Text(
      text,
      style: const TextStyle(
        color: AppColors.secondMainColor,
        fontSize: 18,
        height: .5,
      ),
    );
