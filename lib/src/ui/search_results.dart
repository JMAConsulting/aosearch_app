import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:aoapp/src/queries/search_parameters.dart';
import 'package:aoapp/src/resources/api.dart';
import 'package:html/parser.dart';
import 'package:aoapp/src/ui/full_search_result.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

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
        centerTitle: true,
        backgroundColor: Colors.white70,
        elevation: 4.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Image.asset(
          'images/AO_logo.png',
          height: AppBar().preferredSize.height,
          fit: BoxFit.cover,
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
    final translation = SearchAppLocalizations.of(context);
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
            Localizations.localeOf(context).languageCode.toUpperCase(),
            search.isVerified,
            search.startDate,
            search.endDate,
            true
        ),
      ),
      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
        return Column(
          children: [
            legendIconBlock(translation),
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

  Widget legendIconBlock(translation) {
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
            title: Text(translation.serviceLegendTitle),
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
                              Text(translation.acceptingNewClientsTitle),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_not_accepting_16px.png'),
                              Text(translation.notAcceptingNewClients),
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
                              Text(translation.online),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_local_travel_16px.png'),
                              Text(translation.nearbyAreaTravel),
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
                              Text(translation.removeAreaTravel),
                            ],
                          )
                      ),
                      TableCell(
                          child: Column(
                            children: [
                              Image.asset('images/icon_verified_16px.png'),
                              Text(translation.verifiedListing),
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

class Result extends StatelessWidget {
  Result({@required this.list});
  final list;

  @override
  Widget build(BuildContext context) {
    final translation = SearchAppLocalizations.of(context);
    var baseURL = getbaseUrl(Localizations.localeOf(context).languageCode.toUpperCase());

    return ListView.builder(
        itemCount: list["searchAPISearch"]["documents"].length,
        itemBuilder: (BuildContext context, int index) {
          final item = list["searchAPISearch"]["documents"][index];
          SearchParameters items = SearchParameters();
          items.catagories = [item['type']];
          items.keyword = item['title'];
          String title = getTitle(item);
          String serviceListingID = item['type'] == null ? getItemId(item).toString() : "0";
          return Card(
              elevation: 5,
              child: Padding(
              padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(5.0),
                        height: title.length > 50 ? 100.00 : title.length > 40 ? 80.0 : 50.00,
                        child:  Wrap(
                          spacing: getType(item, true) == 'Service Listing' ? 2 : 0,
                        children: <Widget>[
                          (getType(item, true) == 'Service Listing' && item["custom_911"] != null && item["custom_911"] != 'None' && item["custom_895"] != null) ? Image.asset('images/icon_verified_16px.png') : Text(''),
                          Text(
                          getTitle(item),
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 18.0,
                          ),
                        ),
                          Divider(
                            color: Color.fromRGBO(171, 173, 0, 100),
                            thickness: 3,
                            endIndent: MediaQuery.of(context).size.width * 0.70,
                          ),
                        ]),
                      ),
                      subtitle: Wrap(
                          children: [
                            Row(
                                children: [
                                  Text(getTranslatedTitle(translation, getType(item, false)).toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.grey[850],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12.0
                                    ),
                                  ),
                                  Text(' '),
                                  Query(
                                      options: QueryOptions(
                                          documentNode: gql(getServiceListingInformationQuery),
                                          variables: {"contact_id": serviceListingID, "contactId": serviceListingID}
                                      ),
                                      builder: (QueryResult result1, {VoidCallback refetch, FetchMore fetchMore}) {
                                        if (serviceListingID == "0") {
                                          return Text('');
                                        }
                                        if (result1.hasException) {
                                          return Text(
                                              result1.exception.toString());
                                        }
                                        if (result1.loading) {
                                          return Text('Loading');
                                        }
                                        return Wrap(
                                          spacing: 2,
                                          children: getServicelistingButtons(result1.data["civicrmContactById"]),
                                        );
                                      }),
                                ]
                            )
                          ]
                      ),
                    ),
                    ListTile(
                      subtitle: Table(
                        columnWidths: {
                          0: FlexColumnWidth(5),
                          1: FlexColumnWidth(0.5),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(child: Text(
                                getDescription(item),
                                style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 15.0
                                ),)
                              ),
                              TableCell(
                                  child: new IconButton(
                                    icon: new Icon(Icons.arrow_right),
                                    onPressed: () {
                                      var path = '';
                                      var type = getType(item, true);
                                      if (type == 'Service Listing') {
                                        Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => new FullResultsPage(id: getItemId(item).toString())
                                              )
                                        );
                                      }
                                      else {
                                        if (type == 'Event') {
                                          path = 'civicrm/event/info?id=';
                                        }
                                        else {
                                          path = 'node/';
                                        }
                                        launch(baseURL + path + getItemId(item).toString());
                                      }
                                    },
                                  )
                              )
                            ]
                          )
                        ],
                      )
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
    if (result == null) {
      widgets.add(Text(''));
      return widgets;
    }
    if ((result['custom896'] == '' || result['custom896'] == null) &&
        (result['custom897Jma'] == '' || result['custom_897Jma'] == null)) {
      widgets.add(Text(''));
      return widgets;
    }

    if (result['custom897Jma'].toString().contains('Online')) {
      widgets.add(Image.asset('images/icon_videoconferencing_16px.png'));
    }
    if (result['custom897Jma'].toString().contains('Travels to nearby areas')) {
      widgets.add(Image.asset('images/icon_local_travel_16px.png'));
    }
    if (result['custom897Jma'].toString().contains('Travels to remote areas')) {
      widgets.add(Image.asset('images/icon_remote_travel_16px.png'));
    }
    if (result['custom896'] == true) {
      widgets.add(Image.asset('images/icon_accepting_16px.png'));
    }
    else if (result['custom896'] == false) {
      widgets.add(Image.asset('images/icon_not_accepting_16px.png'));
    }
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

  getType(item, formatCase) {
    var type = item['event_id'] != null ? 'Event' : item['type'];
    type = type ?? 'Service Listing';
    if (formatCase) {
      type = type.replaceAll('_', ' ');
      return toBeginningOfSentenceCase(type);
    }
    return type;
  }

  getTitle(item) {
    var title = item['title'] ?? item["organization_name"] ?? item['tm_x3b_und_title_1'] ?? '';
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

  getTranslatedTitle(translation, originalType) {
    var types = [
      {
        "entityLabel": translation.basicPageLabel.toString(),
        "entityId": "page"
      },
      {
        "entityLabel": translation.chapterLabel.toString(),
        "entityId": "chapter"
      },
      {
        "entityLabel": translation.eventLabel.toString(),
        "entityId": "Event"
      },
      //@TODO title name wrong in translation.learningResource.toString()
      {
        "entityLabel": "Learning Resource",
        "entityId": "learning_resource"
      },
      {
        "entityLabel": translation.newsLabel.toString(),
        "entityId": "article"
      },
      {
        "entityLabel": translation.serviceListingLabel.toString(),
        "entityId": "Service Listing"
      }
    ];
    for (var type in types) {
      if (type['entityId'] == originalType) {
        return type['entityLabel'];
      }
    }
  }

  String getbaseUrl(languageCode) {
    var baseURL = 'https://www.autismontario.com/';
    if (languageCode == 'FR') {
      baseURL = baseURL + 'fr/';
    }
    return baseURL;
  }

}
