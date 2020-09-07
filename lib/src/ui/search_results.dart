import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';
import 'full_search_result.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ResultsPage extends StatelessWidget {
  final SearchParameters search;
  ResultsPage({@required this.search});

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
      body: new SearchResults(search: search),
    ),
    );
  }
}


class SearchResults extends StatefulWidget {
  final SearchParameters search;
  SearchResults({Key key, @required this.search}): super(key:key);

  @override
  _SearchResultsState createState() => _SearchResultsState(search);
}

class _SearchResultsState extends State<SearchResults> {
  final SearchParameters search;
  var type = 'Service Listing';
  _SearchResultsState(this.search);

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
                : result.data["searchAPISearch"]["documents"].length == 0 ? Text(SearchAppLocalizations.of(context).noResultText) : Result(list: result.data),
          ),
        );
      },
    );
  }

  queryVariables(appLanguage, ageGroupsServed, acceptingNewClients,
      servicesProvided, keywords, languages, chapters, categories) {
    var conditionGroupGroups = new List();
    if (ageGroupsServed != null && !ageGroupsServed.isEmpty) {
      conditionGroupGroups.add(buildConditionGroup({"custom_898": ageGroupsServed.join(',')}, "OR", false));
    }
    if (categories != null && !categories.isEmpty) {
      conditionGroupGroups.add(
          buildConditionGroup({"type": categories.join(',')}, "OR", false));
    }
    if (chapters != null && !chapters.isEmpty) {
      conditionGroupGroups.add(
          buildConditionGroup({"field_chapter_reference": chapters.join(',')}, "OR", false));
    }
    if (acceptingNewClients != null && acceptingNewClients != '- Any -' && acceptingNewClients != '- Toutes -') {
      conditionGroupGroups.add(
          buildConditionGroup({"custom_896": "Accepting new clients"}, "OR",
              acceptingNewClients == "Yes" || acceptingNewClients == "Oui" ? false : true));
    }
    if (servicesProvided != null && !servicesProvided.isEmpty) {
      conditionGroupGroups.add(
          buildConditionGroup({"custom_897": servicesProvided.join(',')}, "OR", false));
    }
    if (languages != null && !languages.isEmpty) {
      conditionGroupGroups.add(
        buildConditionGroup({"custom_899": languages.join(',')}, "OR", false)
      );
    }
    var conditionGroup = {
      "conjunction": "AND",
      'groups': conditionGroupGroups,
    };
    var variables = {
      "conditions": [],
      "languages": [appLanguage, "und"],
      'conditionGroup': conditionGroup,
      'fullText': {"keys": keywords},
    };
    return variables;
  }
}

class Result extends StatelessWidget {
  Result({@required this.list});
  final list;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list["searchAPISearch"]["documents"].length,
        itemBuilder: (BuildContext context, int index) {
          final item = list["searchAPISearch"]["documents"][index];
          SearchParameters items = SearchParameters();
          //items.languages = [item['langcode']];
          items.catagories = [item['type']];
          items.keyword = item['title'];
          return Card(
              elevation: 5,
              child: Padding(
              padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new FullResultsPage(search: items)
                            )
                        );
                      },
                      title: Container(
                        padding: EdgeInsets.all(5.0),
                        height: 35.0,
                        child: Text(
                          getTitle(item),
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 18.0
                          ),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 5, // space between two icons
                        children: <Widget>[
                          Image.network('https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_accepting_16px.png'),
                          Image.network('https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_not_accepting_16px.png'),
                          Image.network('https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_videoconferencing_16px.png'),
                          Image.network('https://jma.staging.autismontario.com/modules/custom/jma_customizations/img/icon_local_travel_16px.png'),
                        ],
                      ),
                      //contentPadding: EdgeInsets.symmetric(vertical: 3.5),
                    ),
                    ListTile(
                      trailing: Icon(Icons.arrow_right),
                      subtitle: Text(
                        getDescription(item),
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: geolocationButtons(item),
                    ),
                  ],
                )
              )
            );
          });

  }

  List<Widget> geolocationButtons(result) {
    var widgets = <Widget>[];
    var resultCoordinates = result['field_geolocation'].length > 0 ?
    result['field_geolocation'] : (
        result['field_geolocation_2'].length > 0 ?
        result['field_geolocation_2'] : []
    );
    if (resultCoordinates.length > 0) {
      for (var key = 0; key<resultCoordinates.length; key++) {
        var coordinates = resultCoordinates[key].split(', ');
        widgets.add(RaisedButton(
          onPressed: () =>
              MapsLauncher.launchCoordinates(
                  double.parse(coordinates[0]), double.parse(coordinates[1]),
                  getTitle(result)),
          child: Icon(Icons.map),
        ));
      }
    }
    else {
      widgets.add(Text(''));
    }
    return widgets;
  }

  Widget titleText(text) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 18.0
            ),
          ),
      )
    );
  }

  getTitle(item) {
    var title = item['title'] ?? item["organization_name"] ?? '';
    title = title.replaceAll('Self-employed ', '');

    return title;
  }

  String getDescription(item) {
    var body = parse(item['custom_893'] ?? item['description'] ?? item['body'] ?? '');
    return truncateWithEllipsis(200, parse(body.body.text).documentElement.text);
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}
