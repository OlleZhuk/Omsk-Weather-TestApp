class WeatherData {
  WeatherData({
    required this.time,
    required this.pressure,
    required this.temperatureFL,
    required this.imagePath,
    required this.name,
    required this.temperature,
    required this.conditions,
    required this.windSpeed,
    required this.windGusts,
    required this.humidity,
  });

  final int temperature;
  final int temperatureFL;
  final String conditions;
  final String imagePath;
  final int windSpeed;
  final int windGusts;
  final int humidity;
  final double pressure;
  final String name;
  final String time;
}
