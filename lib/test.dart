import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'class model.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  Position? _currentLoc;
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    //above VARIABLE TO STORE THE RESULT WHETHER THE LOCATION IS ENABLED OR NOT
    LocationPermission permission;//HOLDS THE LOCATION PERMISSION STATUS

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //above CHECKS WHETHER THE LOCATION IS ENABLED USING GEOLOCATOR PACKAGE

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }     // IF LOCATION IS NOT ENABLED, THIS MESSAGE WILL BE SHOWN


    permission = await Geolocator.checkPermission();
    // above CHECKS WHETHER THE PERMISSION IS GRANTED OR DENIED AND STORES IT IN THE VARIABLE permission
    permission = await Geolocator.requestPermission();
    //THE above line SHOW A ALERT BOX TO THE USER TO ALLOW OR BLOCK

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
      // IF LOCATION IS DENIED THIS LINE WILL BE EXECUTED
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      //IF THE PERMISSION IS PERMANENTLY DENIED THE ABOVE LINE IS EXECUTED
    }

    return await Geolocator.getCurrentPosition();//RETURNS THE CURRENT LOCATION
  }
  Future<WeatherModel> fetch() async {
    var result = await http
        .get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${_currentLoc!.latitude}&lon=${_currentLoc!.longitude}&lang=en&&units=metric&appid=b3241b166a34277e9ff8b825b21d91c3"));
    return WeatherModel.fromMap(jsonDecode(result.body));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent.shade200,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: () async{
            Position position = await _getCurrentPosition();
            //CALLS THE FUNCTION AND STORED IN THE VARIABLE
            setState(() {
              _currentLoc = position;
              //THE _currentLoc GETS THE CURRENT LOCATION
            });//SET STATE IS USED CUZ THE VALUE CAN BE CHANGED
            print(_currentLoc!.latitude);
          }, icon: const Icon(Icons.location_on))
          ],
        ),
        body: _currentLoc==null
            ?const Center(child: Text('Press to Get Location Weather'))
            :FutureBuilder(
            future: fetch(),
            builder: (BuildContext context, snapshot){
              if(snapshot.hasData){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.name,style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),),
                      Text(snapshot.data!.country,style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),),
                      Text('${snapshot.data!.temp}°C',style: const TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage('https://openweathermap.org/img/wn/${snapshot.data!.icon}@2x.png'),)
                        ),
                      ),
                      Text('Humidity : ${snapshot.data!.humidity}%',style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),),
                      Text(snapshot.data!.description.toUpperCase(),style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.yellow
                      ),),
                      Text('Min Temperature : ${snapshot.data!.tempMin}°C',style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),),
                      Text('Max Temperature : ${snapshot.data!.tempMax}°C',style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),),
                      Text('Latitude : ${_currentLoc!.latitude.toStringAsFixed(2)}',style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),),
                      Text('Longitude : ${_currentLoc!.longitude.toStringAsFixed(2)}',style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),),

                    ],
                  ),
                );
              }
              else if(snapshot.hasError){
                return Text('Error In Your Server');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            )
    );
  }
}