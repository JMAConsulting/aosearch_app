import 'package:flutter/material.dart';
import 'ui/search_page.dart';

class SearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white70,
            title: SafeArea(
              child: Container(
                height: 100,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/AO_logo.png'),
                    fit: BoxFit.fitHeight
                  )
                ),
              ),
            ),
          ),
          body: SearchPage()
      ),
    );
  }
}

