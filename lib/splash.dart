import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/Tapbar.dart';


class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> tapbars()));
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2,
              width:  MediaQuery.of(context).size.width/1,
              child:  Image.asset("assets/weathersplash_1.gif",
                fit: BoxFit.fill,),
            ),
          ]),
    );
  }
}






