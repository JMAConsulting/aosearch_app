import 'package:flutter/material.dart';
import 'src/search_app.dart';
import 'src/queries/state_container.dart';

void main() {
  runApp(new StateContainer(child: new AOApp()));
}

class AOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SearchApp()
    );
  }
}