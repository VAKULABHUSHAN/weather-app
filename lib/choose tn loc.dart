import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class model.dart';

class chooseTNloc extends StatefulWidget {
  const chooseTNloc({super.key});

  @override
  State<chooseTNloc> createState() => _chooseTNlocState();
}

class _chooseTNlocState extends State<chooseTNloc> {
  String? _selectedCity;
  WeatherModel? _weatherData;

  // List of Tamil Nadu cities
  final List<String> _cities = [
    "Chennai","Coimbatore","Madurai","Tiruchirappalli","Salem","Tirunelveli","Thanjavur",
    "Vellore","Erode","Dindigul","Kanyakumari","Nagapattinam","Perambalur","Thiruvarur",
    "Krishnagiri","Ariyalur","Tenkasi","Namakkal","Cuddalore","Theni",
    "Ramanathapuram", "Pudukkottai","Kanchipuram","Thiruvallur","Tirupur","Villupuram",
    "Chengalpattu","Thoothukudi","Virudhunagar","Thiruvarur",
    "Dindigul","Tirupathur"
  ];

  Future<WeatherModel> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city,Tamil Nadu&lang=en&units=metric&appid=b3241b166a34277e9ff8b825b21d91c3"));

    if (response.statusCode == 200) {
      return WeatherModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void _getWeather() async {
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      try {
        WeatherModel data = await fetchWeather(_selectedCity!);
        setState(() {
          _weatherData = data;
        });
      } catch (e) {
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
            child: TextFormField(
              readOnly: true,  // Make it read-only
              decoration: InputDecoration(
                hintText: 'Select a TN city',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.tealAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () async {
                String? selectedCity = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Select a city'),
                      children: _cities.map((city) {
                        return SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context, city);
                          },
                          child: Text(city),
                        );
                      }).toList(),
                    );
                  },
                );
                if (selectedCity != null) {
                  setState(() {
                    _selectedCity = selectedCity;
                  });
                }
              },
              controller: TextEditingController(text: _selectedCity),
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
