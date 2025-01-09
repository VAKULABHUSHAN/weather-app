import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'class model.dart';

class weatherapp extends StatefulWidget {
  const weatherapp({super.key});

  @override
  State<weatherapp> createState() => _weatherappState();
}

class _weatherappState extends State<weatherapp> {
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: () async{
            Position position = await _getCurrentPosition();
            //CALLS THE FUNCTION AND STORED IN THE VARIABLE
            setState(() {
              _currentLoc = position;
              //THE _currentLoc GETS THE CURRENT LOCATION
            });//SET STATE IS USED CUZ THE VALUE CAN BE CHANGED
          }, icon: const Icon(Icons.location_on,color: Colors.white,))
        ],
      ),
      body: _currentLoc==null?Center(
        child: Container(
                height: 100,
                width: 250,
                decoration:  BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text("TO GET THE CURRENT WEATHER",style:  TextStyle(fontSize: 16),),
                    Text("PRESS THE ABOVE ICON",style:  TextStyle(fontSize: 16),)
                  ],
                )),
              ),
      ):FutureBuilder(
          future: fetch(),
          builder: (BuildContext context , snapshot){
            if(snapshot.hasData){
              return Container(
                height: MediaQuery.of(context).size.height/1,
                width: MediaQuery.of(context).size.width/1,
                decoration:  const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://wallpaper.forfun.com/fetch/d5/d57ba2149ee020e0d4dd25b0396341cb.jpeg"),
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Text(snapshot.data!.name,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                    Text(snapshot.data!.country,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                    Text('Temperature: ${snapshot.data!.temp}°C',style: const TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                    Text(snapshot.data!.description,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                    Text("Humidity:${snapshot.data!.humidity}",style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),),

                    Container(
                      height: 150,
                      width: 150,
                      decoration:  BoxDecoration(
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image:NetworkImage("https://openweathermap.org/img/wn/${snapshot.data!.icon}@2x.png"),fit: BoxFit.fill)
                      ),
                    ),
                    Text('Min Temperature : ${snapshot.data!.tempMin}°C',style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),),
                    Text('Max Temperature : ${snapshot.data!.tempMax}°C',style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),),
                    Text('Latitude : ${_currentLoc!.latitude.toStringAsFixed(2)}',style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),),
                    Text('Longitude : ${_currentLoc!.longitude.toStringAsFixed(2)}',style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25
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
     
     
      // Column(
      //   children: [
      //     Center(
      //       child: GestureDetector(
      //         child: Container(
      //           height: 100,
      //           width: 250,
      //           decoration:  BoxDecoration(
      //             color: Colors.tealAccent,
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: Center(child: const Text("GET THE CURRENT WEATHER ")),
      //         ),
      //         onTap: () async{
      //           Position position = await _getCurrentPosition();
      //           //CALLS THE FUNCTION AND STORED IN THE VARIABLE
      //           setState(() {
      //             _currentLoc = position;
      //             //THE _currentLoc GETS THE CURRENT LOCATION
      //           });//SET STATE IS USED CUZ THE VALUE CAN BE CHANGED
      //         },
      //       ),
      //     )
      //     ],
      // )
    );

  }
}