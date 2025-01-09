import 'package:flutter/material.dart';

import 'choose tn loc.dart';
import 'chose loc.dart';
import 'current.dart';

class tapbars extends StatefulWidget {
  const tapbars({super.key});

  @override
  State<tapbars> createState() => _tapbarsState();
}

class _tapbarsState extends State<tapbars> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: TabBar(
                tabs: [
                  Tab(text: "CURRENT LOCATION"),
                  Tab(text: "TN CITIES"),
                  Tab(text: "CHOOSE CITY"),
                ],
              ),
              title: Text('WEATHER APP',style: const TextStyle(color: Colors.white,),)
            ),
            body: TabBarView(
              children: [
                weatherapp(),
                chooseTNloc(),
                chooseloc()
              ],
            ),
          ),
        );

  }
}
