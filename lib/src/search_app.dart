import 'package:flutter/material.dart';
import 'ui/search_page.dart';
import 'package:aoapp/api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      child: MaterialApp(
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
      ),
      client: client,
    );
  }
}
