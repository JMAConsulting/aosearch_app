import 'package:flutter/material.dart';
import 'src/search_app.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'src/queries/state_container.dart';
import 'package:aoapp/api.dart';
import 'package:html/parser.dart';

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
