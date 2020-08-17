import 'package:flutter/material.dart';
import 'src/search_app.dart';

void main() {
  runApp(new AOApp());
}

class AOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new SearchApp());
  }
}
