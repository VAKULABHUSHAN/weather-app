



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class model.dart';

class chooseloc extends StatefulWidget {
  const chooseloc({super.key});

  @override
  State<chooseloc> createState() => _chooselocState();
}

class _chooselocState extends State<chooseloc> {
  String? _cityName;
  WeatherModel? _weatherData;
  final TextEditingController _controller = TextEditingController();

  Future<WeatherModel> fetchWeather() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$_cityName&lang=en&units=metric&appid=b3241b166a34277e9ff8b825b21d91c3"));

    if (response.statusCode == 200) {
      return WeatherModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void _getWeather() async {
    if (_cityName != null && _cityName!.isNotEmpty) {
      try {
        WeatherModel data = await fetchWeather();
        setState(() {
          _weatherData = data;
        });
      } catch (e) {
        // Handle error (e.g., show a message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching weather data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.tealAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _cityName = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _getWeather,
            child: const Text('Get Weather'),
          ),
          if (_weatherData != null) ...[
            Column(
              children: [
                SizedBox(height: 30),
                Text(_weatherData!.name, style: const TextStyle(color: Colors.white, fontSize: 25)),
                Text(_weatherData!.country, style: const TextStyle(color: Colors.white, fontSize: 25)),
                Text('Temperature: ${_weatherData!.temp}°C', style: const TextStyle(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(_weatherData!.description, style: const TextStyle(color: Colors.white, fontSize: 25)),
                Text("Humidity: ${_weatherData!.humidity}%", style: const TextStyle(color: Colors.blue, fontSize: 25)),
                Text('Min Temperature: ${_weatherData!.tempMin}°C', style: const TextStyle(color: Colors.white, fontSize: 25)),
                Text('Max Temperature: ${_weatherData!.tempMax}°C', style: const TextStyle(color: Colors.white, fontSize: 25)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

