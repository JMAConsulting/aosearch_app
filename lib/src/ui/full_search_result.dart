import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';

class FullResultsPage extends StatelessWidget {
  final SearchParameters search;

  FullResultsPage({@required this.search});

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
        body: new FullSearchResults(search: search),
      ),
    );
  }
}

class FullSearchResults extends StatefulWidget {
  final SearchParameters search;
  FullSearchResults({Key key, @required this.search}): super(key:key);

  @override
  _FullSearchResultsState createState() => _FullSearchResultsState(search);
}

class _FullSearchResultsState extends State<FullSearchResults> {
  final SearchParameters search;
  var type = 'Service Listing';

  _FullSearchResultsState(this.search);

  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      print('Building SearchResults');
       return Query(
        options: QueryOptions(
          documentNode: gql(query),
          variables: queryVariables(
            Localizations.localeOf(context).languageCode,
            search.ageGroupsServed,
            search.acceptingNewClients,
            search.servicesAreProvided,
            search.keyword,
            search.languages,
            search.chapters,
            search.catagories,
          ),
        ),
        builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
          return SafeArea(
            child: Center(
              child: result.hasException
                  ? Text(result.exception.toString())
                  : result.loading
                  ? CircularProgressIndicator()
                  : result.data["searchAPISearch"]["documents"].length == 0 ? Text(SearchAppLocalizations.of(context).noResultText) : FullResult(list: result.data),
            ),
          );
        },
      );
    }
  }

  queryVariables(appLanguage, ageGroupsServed, acceptingNewClients,
      servicesProvided, keywords, languages, chapters, categories) {
    var conditionGroupGroups = new List();

    var conditionGroup = {
      "conjunction": "AND",
      'groups': conditionGroupGroups,
    };
    var variables = {
      "conditions": [],
      "languages": [appLanguage, "und"],
      'conditionGroup': conditionGroup,
      'fullText': {"keys": "aa"},
    };
    return variables;
  }
}

class FullResult extends StatelessWidget {
  FullResult({@required this.list});
  final list;

  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      return ListView.builder(
          itemCount: list["searchAPISearch"]["documents"].length,
          itemBuilder: (BuildContext context, int index) {
            final item = list["searchAPISearch"]["documents"][index];
            return Card(
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          title: Container(
                            padding: EdgeInsets.all(5.0),
                            height: 35.0,
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                  color: Colors.grey[850],
                                  fontSize: 18.0
                              ),
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 5, // space between two icons
                            children: <Widget>[
                              Image.network(
                                  'https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_accepting_16px.png'),
                              Image.network(
                                  'https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_not_accepting_16px.png'),
                              Image.network(
                                  'https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_videoconferencing_16px.png'),
                              Image.network(
                                  'https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_local_travel_16px.png'),
                            ],
                          ),
                        ),
                        ListTile(
                          trailing: Icon(Icons.arrow_right),
                          subtitle: Text(
                            item['custom_893']
                                ? item['description']
                                : item['body'],
                            style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 15.0
                            ),
                          ),
                        ),
                      ],
                    )
                )
            );
          });
    }
  }
}