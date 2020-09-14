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
        body: ListView(
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
                                        endIndent: 220,
                                      ),
                                    ]),
                              ),
                              subtitle: Wrap(
                                children: [
                                  Row(
                                    children: [
                                      Text('SERVICE LISTING',
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontStyle: FontStyle.italic,
                                            fontSize: 11.0
                                        ),
                                      ),
                                      Text(' '),
                                      Row(
                                        children: getServicelistingButtons(result.data['civicrmContactById']),
                                      )
                                    ]
                                  )
                                ]
                              )
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
                        Query(
                            options: QueryOptions(
                              documentNode: gql(getPrimaryContactQuery),
                              variables: {"contact_id": getPrimaryContactID(result.data['civicrmRelationshipJmaQuery']['entities'])},
                            ),
                            builder: (QueryResult result5, {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result5.hasException) {
                                return Text(result5.exception.toString());
                              }
                              if (result5.loading) {
                                return Text('Loading');
                              }
                              return Row(
                                  children: [
                                    Linkify(
                                      onOpen: _onOpen,
                                      text: getPrimaryContactInfo(result5.data["civicrmEmailJmaQuery"]["entities"], result.data['civicrmRelationshipJmaQuery']['entities']),
                                    )
                                  ]
                              );
                            }
                        ),
                        SizedBox(height: 10),
                            ListTile(
                              title: Text('Description of services offered:', style: TextStyle(fontSize: 14)),
                              subtitle: Text(result.data['civicrmContactById']['custom893']),
                        ),
                        SizedBox(height: 5),
                        ListTile(
                                  title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Linkify(
                                          onOpen: _onOpen,
                                          text: "Email: " + getEmails(result.data['civicrmEmailJmaQuery']['entities']),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                        children: [
                                          Text('Phone: ', style: TextStyle(fontSize: 15)),
                                          Row(
                                              children: getPhones(result.data['civicrmPhoneJmaQuery']['entities'])
                                          )
                                        ]),
                                        SizedBox(height: 5),
                                        Linkify(
                                          onOpen: _onOpen,
                                          text: "Website: " + getWebsites(result.data['civicrmWebsiteJmaQuery']['entities']),
                                        ),
                                        SizedBox(height: 10),
                                        Text('Age Groups Served: ' + result.data['civicrmContactById']['custom898'], style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 5),
                                        Text('Language(s): ' + result.data['civicrmContactById']['custom905'], style: TextStyle(fontSize: 14)),
                                      ]
                                  ),
                                ),
                            SizedBox(height: 10),
                            Column(
                                children: getAddressBlock(result.data['civicrmAddressJmaQuery']['entities'], result.data['civicrmContactById'])
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

  getWebsites(websites) {
    List websiteString = [];
    for (var website in websites) {
      websiteString.add(website["url"]);
    }
    return websiteString.join(", ");
  }

  getEmails(emails) {
    List emailString = [];
    for (var email in emails) {
      emailString.add(email["email"]);
    }
    return emailString.join(", ");
  }

  getPhones(phones) {
    var phoneBlocks = <Material>[];
    for(var phone in phones) {
      phoneBlocks.add(Material(
          child: InkWell(
            onTap: () {
              launch('tel:' +
                  phone['phone']);
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Text(
                  phone['phone'],
                  style: TextStyle(color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontSize: 15),
                ),
              ),),
          )
      ));
    }
    return phoneBlocks;
  }

  getAddressBlock(addresses, contact) {
    var addressBlocks = <ListTile>[];
    for (var address in addresses) {
      addressBlocks.add( ListTile(
        title: Material(
            child: InkWell(
              onTap: () {
                MapsLauncher.launchCoordinates(
                    double.parse(address['geoCode1'].toString()),
                    double.parse(address['geoCode2'].toString()),
                    getTitle(contact['civicrmContactById'])
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
            Text(address['streetAddress'], textAlign: TextAlign.left),
            Text(address['city'] + ', ON', textAlign: TextAlign.left),
            Text(address['postalCode'], textAlign: TextAlign.left),
          ],
        ),
      ));
    }
    return addressBlocks;
  }

  getPrimaryContactID(serviceProviders) {
    for (var serviceProvider in serviceProviders) {
      if (serviceProvider["relationshipTypeId"] == 74) {
        return serviceProvider["contactIdA"]["entity"]["entityId"];
      }
    }
  }

  getPrimaryContactInfo(emailInfo, serviceProviders) {
      for (var serviceProvider in serviceProviders) {
          if (serviceProvider["relationshipTypeId"] == 74) {
            for(var email in emailInfo) {
              return '     ' + serviceProvider["contactIdA"]["entity"]["displayName"] + ' ' + email["email"];
            }
          }
        }
    }

  buildRegulatorServiceProvided(regualtedServices, serviceProviders) {
    var widgets = <Widget>[];
    var count, count1 = 0;
    for (var serviceProvider in serviceProviders) {
      if (serviceProvider["relationshipTypeId"] == 5 && serviceProvider["contactIdA"]["entity"]["custom954"] != '') {
        if (count == 0) {
          widgets.add(Text('Regulated Services Provided: ', style: TextStyle(fontSize: 14)));
        }
        else {
          widgets.add(Text(', '));
        }
        widgets.add(Text(serviceProvider["contactIdA"]["entity"]["custom954"], style: TextStyle(fontSize: 14)));
        count++;
      }
    }
    for (var serviceProvider in serviceProviders) {
      if (serviceProvider["relationshipTypeId"] == 5 && serviceProvider["contactIdA"]["entity"]["custom953"] != '') {
        if (count1 == 0) {
          widgets.add(Text('Credential(s) held: ', style: TextStyle(fontSize: 14)));
        }
        else {
          widgets.add(Text(', '));
        }
        widgets.add(Text(serviceProvider["contactIdA"]["entity"]["custom953"]));
        count1++;
      }
    }

    return widgets;
  }

  buildRegulatorServices(regualtedServices, serviceProviders) {
    var widgets = <Widget>[];
    for (var serviceProvider in serviceProviders) {
      if (serviceProvider["relationshipTypeId"] == 5) {
        widgets.add(
          Row(
            children: [
              Row(
                children: [
                  Image.asset('images/icon_verified_16px.png'),
                  Text(
                      serviceProvider["contactIdA"]["entity"]["displayName"] + (
                          serviceProvider["contactIdA"]["entity"]["custom954"] ==
                              '' ? (
                              serviceProvider["contactIdA"]["entity"]["custom953"] ==
                                  '' ?
                              '' : " (" +
                                  serviceProvider["contactIdA"]["entity"]["custom953"] +
                                  ")")
                              : " (" +
                              serviceProvider["contactIdA"]["entity"]["custom954"] +
                              ")")),
                ],
              ),
            ],
          ),
        );
        widgets.add(SizedBox(height: 10));
      }
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
    if ((result['custom896'] == '' || result['custom896'] == null) &&
        (result['custom897'] == '' || result['custom897'] == null)) {
      widgets.add(Text(''));
      return widgets;
    }

    if (result['custom896'] == true) {
      count++;
      widgets.add(Image.asset('images/icon_accepting_16px.png'));
      widgets.add(Text(' '));
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