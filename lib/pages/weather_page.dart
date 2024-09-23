import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService("4c0cdbc5a3a350976a82e13fec8ef9ae");
  Weather? _weather;

  // fetch weather
  _featchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

  // any errors
  catch (e) {
    print(e);
  }
}

// weather animations
String getWeatherAnimation(String? mainCondition){
  if (mainCondition == null) return 'assets/sunny.json'; // deafault to sunny
  switch (mainCondition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assests/cloudy.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/raining.json';
    case 'thunderstorm':
      return 'assets/storm';
    case 'clear':
      return 'assets/sunny.json';
    default:
      return 'assets/sunny.json';
  }
}

// init state
@override
  void initState() {
    super.initState();

  // fetch weather on startup
  _featchWeather();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // city name
          Text(_weather?.cityName ?? "loading city.."),
          
          // animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

          // temperature
          Text('${_weather?.temperature.round()}°C'),

          // weather condition
          Text(_weather?.mainCondition ?? "")

          ],
        ),
      ),
    );
  }
}
