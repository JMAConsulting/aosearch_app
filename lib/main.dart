import 'package:flutter/material.dart';
import 'src/search_app.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'src/resources/api.dart';

void main() {
  runApp(new AOApp());
}

class AOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: new MaterialApp(home: new SearchApp()),
    );
  }
}

