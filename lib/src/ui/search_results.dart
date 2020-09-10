import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';
import 'full_search_result.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

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

        return Column(
          children: [
            legendIconBlock(),
            Container(
              child: result.hasException
                  ? Text(result.exception.toString())
                  : result.loading
                    ? Center(child: CircularProgressIndicator())
                    : result.data["searchAPISearch"]["documents"].length == 0 ? Text(SearchAppLocalizations.of(context).noResultText) : Expanded(child: Result(list: result.data)),
            )
          ],
        );
      },
    );
  }
}

  Widget legendIconBlock() {
    const rowSpacer=TableRow(
        children: [
          SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 18,
          )
        ]);
    return SingleChildScrollView(
        child: Card(
          child: ExpansionTile(
            title: Text('Service Listing Legend'),
            initiallyExpanded: true,
            children: [
              SizedBox(height: 10.0),
              Table(
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_accepting_16px.png'),
                              Text('Accepting new clients'),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_not_accepting_16px.png'),
                              Text('Not accepting new clients'),
                            ],
                          )
                      ),
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_videoconferencing_16px.png'),
                              Text('Online'),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_local_travel_16px.png'),
                              Text('Travels to nearby areas'),
                            ],
                          )
                      ),
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_remote_travel_16px.png'),
                              Text('Travels to remote areas'),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_verified_16px.png'),
                              Text('Verified Listing'),
                            ],
                          )
                      ),
                    ]),
                    rowSpacer,
                  ]
              ),
            ],
          ))
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
    };
    if (keywords.length > 0) {
      variables['fullText'] = {"keys": keywords};
      variables['conditionGroup'] = new List();
    }
    return variables;
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
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new FullResultsPage(keyword: getTitle(item))
                            )
                        );
                         */
                      },
                      title: Container(
                        padding: EdgeInsets.all(5.0),
                        height: 50.0,
                        child:  Wrap(
                          spacing: getType(item['type']) == 'Service Listing' ? 2 : 0,
                        children: <Widget>[
                          getType(item['type']) == 'Service Listing' ? Image.asset('images/icon_verified_16px.png') : Text(''),
                          Text(
                          getTitle(item),
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 18.0
                          ),
                        ),

                        ]),
                      ),
                      subtitle: Text(getType(item['type']),
                          style: TextStyle(
                      )),
                      trailing: Wrap(
                        spacing: 5, // space between two icons
                        children: getServicelistingButtons(item),
                      ),
                    ),
                    ListTile(
                      trailing: new IconButton(
                        icon: new Icon(Icons.arrow_right),
                        onPressed: () {
                          var path = '';
                          var type = getType(item['type']);
                          if (type == 'Service Listing') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new FullResultsPage(id: getItemId(item).toString())
                                )
                            );
                            path = 'service-listing/';
                          }
                          else if (type == 'Event') {
                            path = 'civicrm/event/info?id=';
                          }
                          else {
                            path = 'node/';
                          }
                          var url = 'https://jma.staging.autismontario.com/' + path + getItemId(item).toString();
                          //launch(url);
                        },
                      ),
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

    List <Widget> getServicelistingButtons(result) {
    var widgets = <Widget>[];
    var count = 0;
    if ((result['custom_896'] == '' || result['custom_896'] == null) &&
        (result['custom_897'] == '' || result['custom_897'] == null)) {
      widgets.add(Text(''));
      return widgets;
    }

    if (result['custom_896'] == '1') {
      count++;
      widgets.add(Image.asset('images/icon_accepting_16px.png'));
    }
    else if (result['custom_896'] == '0') {
      widgets.add(Image.asset('images/icon_not_accepting_16px.png'));
    }
    if (result['custom_897'].indexOf('2') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_videoconferencing_16px.png'));
    }
    if (result['custom_897'].indexOf('3') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_local_travel_16px.png'));
    }
    if (result['custom_897'].indexOf('4') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_remote_travel_16px.png'));
    }

    //widgets.add(Text(result['custom_896']));
    return widgets;
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

        widgets.add(
            Material(
                child: InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        double.parse(coordinates[0]), double.parse(coordinates[1]),
                        getTitle(result));
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset('images/map.png',
                          width: 110.0, height: 60.0),
                    ),),
                )
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

  getType(type) {
    type = type ?? 'Service Listing';
    type = type.replaceAll('_', ' ');
    return toBeginningOfSentenceCase(type);
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

  getItemId(item) {
    return item['nid'] == null ? (
      item['event_id']  == null ? item['id'] : item['event_id']
    ) : item['nid'];
  }

}
