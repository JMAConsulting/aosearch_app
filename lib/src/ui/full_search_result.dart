import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

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
                                        getTitle(result.data['civicrmContactById']),
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: 15.0
                                        ),
                                      ),
                                      Divider(
                                        color: Color.fromRGBO(171, 173, 0, 100),
                                        thickness: 3,
                                        //indent: 20,
                                        endIndent: 150,
                                      ),
                                    ]),
                              ),
                              trailing: Wrap(
                                spacing: 2,
                                children:  getServicelistingButtons(result.data['civicrmContactById']),
                              ),
                              subtitle: Wrap(
                                children: [
                                  Text('SERVICE LISTING',
                                    style: TextStyle(
                                        color: Colors.grey[850],
                                        fontStyle: FontStyle.italic,
                                        fontSize: 11.0
                                    ),
                                ),
                              ])
                        ),
                        Query(
                            options: QueryOptions(
                              documentNode: gql(optionValueQuery),
                              variables: {"value": "regulated_services_provided_20200226231106"},
                            ),
                            builder: (QueryResult result1, {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result1.hasException) {
                                return Text(result1.exception.toString());
                              }
                              if (result1.loading) {
                                return Text('Loading');
                              }
                              return ListTile(
                                  title: Row(children :buildRegulatorServiceProvided(result1.data["civicrmOptionValueJmaQuery"]['entities'], result.data['civicrmRelationshipJmaQuery']['entities']))
                              );
                            }
                        ),
                        ListTile(
                          title: Text('Description of services offered:', style: TextStyle(fontSize: 15),),
                          subtitle: Text(result.data['civicrmContactById']['custom893']),
                        ),
                        SizedBox(height: 10),
                        Row(
                            children: [
                              Linkify(
                              onOpen: _onOpen,
                              text: "    Email: " + result.data['civicrmEmailJmaQuery']['entities'][0]['email'],
                            )]),
                            SizedBox(height: 10),
                             Row(
                              children: [
                                Text('    Phone: '),
                              Material(
                                child: InkWell(
                                  onTap: () {
                                    launch('tel:' + result.data['civicrmPhoneJmaQuery']['entities'][0]['phone']);
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Text(result.data['civicrmPhoneJmaQuery']['entities'][0]['phone'], style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),),
                                    ),),
                                )
                              )
                            ]),
                            SizedBox(height: 10),
                            Row(
                                children: [
                                  Linkify(
                                  onOpen: _onOpen,
                                  text: "    Website: " + result.data['civicrmWebsiteJmaQuery']['entities'][0]['url'],
                                )]),
                                SizedBox(height: 20),
                                ListTile(
                                  title: Material(
                                    child: InkWell(
                                    onTap: () {
                                      MapsLauncher.launchCoordinates(
                                          double.parse(result.data['civicrmAddressJmaQuery']['entities'][0]['geoCode1'].toString()),
                                          double.parse(result.data['civicrmAddressJmaQuery']['entities'][0]['geoCode2'].toString()),
                                          getTitle(result.data['civicrmContactById'])
                                      );
                                    },
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Image.asset('images/map.png',
                                            width: 80.0, height: 60.0),
                                      ),),
                                  )
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(result.data['civicrmAddressJmaQuery']['entities'][0]['streetAddress'], textAlign: TextAlign.left),
                                  Text(result.data['civicrmAddressJmaQuery']['entities'][0]['city'] + ', ON', textAlign: TextAlign.left),
                                  Text(result.data['civicrmAddressJmaQuery']['entities'][0]['postalCode'], textAlign: TextAlign.left),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Query(
                                options: QueryOptions(
                                  documentNode: gql(optionValueQuery),
                                  variables: {"value": "regulated_services_provided_20200226231106"},
                                ),
                                builder: (QueryResult result2, {VoidCallback refetch, FetchMore fetchMore}) {
                                  if (result2.hasException) {
                                    return Text(result2.exception.toString());
                                  }
                                  if (result2.loading) {
                                    return Text('Loading');
                                  }
                                  return Column(children :buildRegulatorServices(result2.data["civicrmOptionValueJmaQuery"]['entities'], result.data['civicrmRelationshipJmaQuery']['entities']));
                                }
                            )
                        ]
                      )
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildRegulatorServiceProvided(regualtedServices, serviceProviders) {
    var widgets = <Widget>[];
    var count = 0;
    for (var serviceProvider in serviceProviders) {
      if (serviceProvider["contactIdA"]["entity"]["custom954"] != null && serviceProvider["contactIdA"]["entity"]["custom954"] != '') {
        if (count == 0) {
          widgets.add(Text('Regulated Services Provided: ', style: TextStyle(fontSize: 15)));
        }
        else {
          widgets.add(Text(', '));
        }
        widgets.add(Text(serviceProvider["contactIdA"]["entity"]["custom954"]));
        count++;
      }
    }
    if (count == 0) {
      widgets = <Widget>[];
      for (var serviceProvider in serviceProviders) {
        if (serviceProvider["contactIdA"]["entity"]["custom953"] != null && serviceProvider["contactIdA"]["entity"]["custom953"] != '') {
          if (count == 0) {
            widgets.add(Text('Credential(s) held: ', style: TextStyle(fontSize: 15)));
          }
          else {
            widgets.add(Text(', '));
          }
          widgets.add(Text(serviceProvider["contactIdA"]["entity"]["custom953"]));
          count++;
        }
      }
    }

    return widgets;
  }

  buildRegulatorServices(regualtedServices, serviceProviders) {
    var widgets = <Widget>[];
    for (var serviceProvider in serviceProviders) {
      widgets.add(
        Row(
          children: [
            Row(
              children: [
                Image.asset('images/icon_verified_16px.png'),
                Text(serviceProvider["contactIdA"]["entity"]["displayName"] + (
                    serviceProvider["contactIdA"]["entity"]["custom954"] == '' ? (
                        serviceProvider["contactIdA"]["entity"]["custom953"] == '' ?
                          '' :  " (" +  serviceProvider["contactIdA"]["entity"]["custom953"] + ")")
                          : " (" + serviceProvider["contactIdA"]["entity"]["custom954"] + ")")),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      );
    }

    return widgets;
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  List <Widget> getServicelistingButtons(result) {
    var widgets = <Widget>[];
    var count = 0;
    //debugPrint(result.toString());
    if ((result['custom896'] == '' || result['custom896'] == null) &&
        (result['custom897'] == '' || result['custom897'] == null)) {
      widgets.add(Text(''));
      return widgets;
    }

    if (result['custom896'] == true) {
      count++;
      widgets.add(Image.asset('images/icon_accepting_16px.png'));
    }
    else if (result['custom896'] == false) {
      widgets.add(Image.asset('images/icon_not_accepting_16px.png'));
    }
    if (result['custom897'].indexOf('2') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_videoconferencing_16px.png'));
    }
    if (result['custom897'].indexOf('3') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_local_travel_16px.png'));
    }
    if (result['custom897'].indexOf('4') >= 0) {
      count++;
      widgets.add(Image.asset('images/icon_remote_travel_16px.png'));
    }
    return widgets;
  }

  getTitle(item) {
    var title = item["organizationName"] ?? '';
    title = title.replaceAll('Self-employed ', '');

    return title;
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

}