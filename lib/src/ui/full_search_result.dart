import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';

class FullResultsPage extends StatelessWidget {
  final String id;

  FullResultsPage({@required this.id});

  @override
  Widget build(BuildContext context) {
    print("Building ResultsPage");
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/AO_logo.png',
                height: AppBar().preferredSize.height,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Card(
              child: Query(
                 options: QueryOptions(
                   documentNode: gql(getServiceListingInformationQuery),
                   variables: {"contact_id": this.id, "contactId": this.id}
                 ),
                builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.loading) {
                    return Text('Loading');
                  }
                  return Card(
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            ListTile(
                              title: Container(
                                padding: EdgeInsets.all(5.0),
                                height: 50.0,
                                child:  Wrap(
                                    spacing: 2,
                                    children: <Widget>[
                                      Image.asset('images/icon_verified_16px.png'),
                                      Text(
                                        result.data.civicrmContactById.organizationName,
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 18.0
                                        ),
                                      ),
                                    ]),
                              )
                            )
                          ],
                        ),
                      )
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}