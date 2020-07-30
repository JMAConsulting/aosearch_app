import 'package:flutter/material.dart';
import 'ui/search_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white70,
            title: Container(
              padding: EdgeInsets.all(10.0),
              child: Image.asset('images/AO_logo.png'),
            ),
          ),
          body: SearchPage()
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}

