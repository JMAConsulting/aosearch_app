import 'package:aoapp/src/search_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aoapp/src/queries/search_parameters.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:aoapp/src/ui/location.dart';
import 'package:aoapp/src/ui/search_results.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aoapp/src/resources/api.dart';

class AdvancedSearchForm extends StatefulWidget {
  @override
  _AdvancedSearchFormState createState() {
    return _AdvancedSearchFormState();
  }
}

class _AdvancedSearchFormState extends State<AdvancedSearchForm> {
  SearchParameters _formResult = SearchParameters();
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');
  final TextEditingController _controller = new TextEditingController();
  DateTime _startDate;

  @override
  Widget build(BuildContext context) {
    final translation = SearchAppLocalizations.of(context);
    if (_formResult.locale != Localizations.localeOf(context).languageCode) {
      setState(() {
        _formResult.locale = Localizations.localeOf(context).languageCode;
      });
    }
    return GraphQLProvider(
        client: Localizations.localeOf(context).languageCode == 'en' ? client : frenchClient,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: Text(SearchAppLocalizations.of(context).keywordHintText).data,
                    labelText: Text(SearchAppLocalizations.of(context).keywordText).data,
                    suffixIcon: IconButton(
                      onPressed: () => _controller.clear(),
                      icon: Icon(Icons.clear),
                    )
                  ),
                  onChanged: (value) {
                    setState(() {
                      _formResult.keyword = value;
                    });
                  },
                  onSaved: (keyword) {
                    setState(() {
                      _formResult.keyword = keyword;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                ExpansionTile(
                  title: Text(SearchAppLocalizations.of(context).advSearchTitle),
                  children: [
                    Column(
                      children: [
                        FlatButton(
                          child: Text('Reset'),
                          onPressed: () {
                            setState(() {
                              _formResult = SearchParameters();
                            });
                          },
                        ),
                        Query(
                            options: QueryOptions(
                            documentNode: gql(facetsQuery),
                            variables: queryVariables(
                            Localizations.localeOf(context).languageCode,
                              _formResult.ageGroupsServed,
                              _formResult.acceptingNewClients,
                              _formResult.servicesAreProvided,
                              _formResult.keyword,
                              _formResult.languages,
                              _formResult.chapters,
                              _formResult.catagories,
                              Localizations.localeOf(context).languageCode.toUpperCase(),
                              _formResult.isVerified,
                              _formResult.startDate,
                              _formResult.endDate,
                                true
                            ),
                            ),
                            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                              var catagories = new List();
                              if (result.loading) {
                                return Text('Loading');
                              }
                              if (result.hasException || result.data["searchAPISearch"] == null) {
                                _formResult.catagories = new List();
                              }
                              else {
                                if (getCatagories(translation, result.data["searchAPISearch"]["facets"]).isEmpty) {
                                  _formResult.catagories = new List();
                                }
                                else {
                                  catagories = getCatagories(translation, result.data["searchAPISearch"]["facets"]);
                                }
                              }
                              return MultiSelectFormField(
                                initialValue: _formResult.catagories,
                                titleText: Text(SearchAppLocalizations
                                    .of(context)
                                    .categoryTitle).data,
                                dataSource: catagories,
                                valueField: 'entityId',
                                textField: 'entityLabel',
                                onSaved: (values) {
                                  setState(() {
                                    _formResult.catagories = values;
                                  });
                                },
                              );
                            }
                        ),
                        Query(
                          options: QueryOptions(
                            documentNode: gql(facetsQuery),
                            variables: queryVariables(
                              Localizations.localeOf(context).languageCode,
                                _formResult.ageGroupsServed,
                                _formResult.acceptingNewClients,
                                _formResult.servicesAreProvided,
                                _formResult.keyword,
                                _formResult.languages,
                                _formResult.chapters,
                                _formResult.catagories,
                                Localizations.localeOf(context).languageCode.toUpperCase(),
                                _formResult.isVerified,
                                _formResult.startDate,
                                _formResult.endDate,
                                true
                            ),
                          ),
                          builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                            var chapters = new List();
                            if (result.loading) {
                              return Text('Loading');
                            }
                            if (result.hasException || result.data["searchAPISearch"] == null) {
                              _formResult.chapters = new List();
                            }
                            else {
                              if (getChapters(result.data["taxonomyTermJmaQuery"]["entities"], result.data["searchAPISearch"]["facets"]).isEmpty) {
                                _formResult.chapters = new List();
                              }
                              else {
                                chapters = getChapters(result.data["taxonomyTermJmaQuery"]["entities"], result.data["searchAPISearch"]["facets"]);
                              }
                            }
                            debugPrint(_formResult.catagories.toString());
                            return MultiSelectFormField(
                              initialValue: _formResult.chapters,
                              titleText: Text(SearchAppLocalizations
                                .of(context)
                                .chaptersTitle).data,
                              dataSource: chapters,
                              valueField: 'entityId',
                              textField: 'entityLabel',
                              change: (value) {
                                setState(() {
                                  _formResult.chapters = value;
                                });
                              },
                              onSaved: (values) {
                                setState(() {
                                  _formResult.chapters = values;
                                });
                              },
                            );
                          }
                        ),
                        Visibility(
                            visible: (_formResult.catagories != null && _formResult.catagories.contains('Service Listing') || _formResult.catagories == null),
                            child: DropDownFormField(
                              value: _formResult.acceptingNewClients,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(12, 12, 14, 0),
                                labelText: Text(SearchAppLocalizations
                                    .of(context)
                                    .acceptingNewClientsTitle).data,
                                labelStyle: TextStyle(fontSize: 17.0, color: Colors.black54),
                              ),
                              dataSource: [
                                {'label': Text(SearchAppLocalizations.of(context).anyText).data},
                                {'label': Text(SearchAppLocalizations.of(context).yesText).data, "value": true},
                                {'label': Text(SearchAppLocalizations.of(context).noText).data, "value": false},
                              ],
                              valueField: 'value',
                              textField: 'label',
                              onChanged: (value) {
                                setState(() {
                                  _formResult.acceptingNewClients = value;
                                });
                              },
                              onSaved: (value) {
                                _formResult.acceptingNewClients = value;
                              },
                              optionStyle: TextStyle(color: Colors.grey.shade500),
                              iconColor: Colors.black87,
                          )
                        ),
                        SizedBox(height: 8.0),
                        Visibility(
                          visible: (_formResult.catagories != null && _formResult.catagories.contains('Service Listing') || _formResult.catagories == null),
                          child: DropDownFormField(
                            value: _formResult.isVerified,
                            decoration: InputDecoration(
                              labelText: 'Is Verified?',
                              labelStyle: TextStyle(fontSize: 17.0, color: Colors.black54),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 14, 0),
                            ),
                            dataSource: [
                              {'label': Text(SearchAppLocalizations.of(context).anyText).data},
                              {'label': Text(SearchAppLocalizations.of(context).yesText).data, "value": true},
                              {'label': Text(SearchAppLocalizations.of(context).noText).data, "value": false},
                            ],
                            valueField: 'value',
                            textField: 'label',
                            onChanged: (value) {
                              setState(() {
                                _formResult.isVerified = value;
                              });
                            },
                            onSaved: (value) {
                              _formResult.isVerified = value;
                            },
                            optionStyle: TextStyle(color: Colors.grey.shade500),
                            iconColor: Colors.black87,
                          )
                        ),
                        Query(
                          options: QueryOptions(
                            documentNode: gql(optionValueQuery),
                            variables: {"value": "105"},
                          ),
                          builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.loading) {
                              return Text('Loading');
                            }
                            return MultiSelectFormField(
                              titleText: Text(SearchAppLocalizations
                                .of(context)
                                .languagesTitle).data,
                              dataSource: getLanguages(result.data["civicrmOptionValueJmaQuery"]["entities"]),
                              valueField: 'entityId',
                              textField: 'entityLabel',
                              hintText: Text(SearchAppLocalizations.of(context).languagesHintText).data,
                              change: (value) {
                                setState(() {
                                  _formResult.languages = value;
                                });
                              },
                              onSaved: (values) {
                                _formResult.languages = values;
                              },
                            );
                          }
                        ),
                        SizedBox(height: 8.0),
                        Visibility(
                          visible: (_formResult.catagories != null && _formResult.catagories.contains('Service Listing') || _formResult.catagories == null),
                          child: Query(
                            options: QueryOptions(
                              documentNode: gql(optionValueQuery),
                              variables: {"value": "232"},
                            ),
                            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result.hasException) {
                                return Text(result.exception.toString());
                              }
                              if (result.loading) {
                                return Text('Loading');
                              }
                              return MultiSelectFormField(
                                titleText: Text(SearchAppLocalizations.of(context).servicesAreProvidedTitle).data,
                                dataSource: result.data["civicrmOptionValueJmaQuery"]["entities"],
                                valueField: 'entityLabel',
                                textField: 'entityLabel',
                                hintText: Text(SearchAppLocalizations.of(context).servicesAreProvidedHintText).data,
                                onSaved: (values) {
                                  _formResult.servicesAreProvided = values;
                                },
                              );
                            }
                          )
                        ),
                        SizedBox(height: 8.0),
                        Query(
                          options: QueryOptions(
                            documentNode: gql(optionValueQuery),
                            variables: {"value": "233"},
                          ),
                          builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.loading) {
                              return Text('Loading');
                            }

                            return MultiSelectFormField(
                              titleText: Text(SearchAppLocalizations.of(context).ageGroupsTitleText).data,
                              dataSource: result.data["civicrmOptionValueJmaQuery"]["entities"],
                              valueField: 'entityLabel',
                              textField: 'entityLabel',
                              hintText: Text(SearchAppLocalizations.of(context).ageGroupsHintText).data,
                              onSaved: (values) {
                                _formResult.ageGroupsServed = values;
                              },
                            );
                          }
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(SearchAppLocalizations.of(context).startDate),
                                SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: DateTimeField(
                                    format: dateFormat,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                        context: context,
                                        initialDate: currentValue ?? DateTime.now(),
                                        firstDate: DateTime(DateTime.now().year - 1),
                                        lastDate: DateTime(DateTime.now().year + 3)
                                      );
                                    },
                                    onChanged: (value) {
                                     _startDate = value;
                                     },
                                    onSaved: (value) {
                                      _formResult.startDate = value;
                                    },
                                  ),
                                ),
                              ]
                            ),
                            Column(
                              children: [
                                Text(SearchAppLocalizations.of(context).endDate),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: DateTimeField(
                                    format: dateFormat,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                        context: context,
                                        initialDate: currentValue ?? DateTime.now(),
                                        firstDate: DateTime(DateTime.now().year - 1),
                                        lastDate: DateTime(DateTime.now().year + 3)
                                      );
                                    },
                                    onSaved: (value) {
                                     _formResult.endDate = value;
                                    },
                                     validator: (value) {
                                      if (value != null && _startDate != null) {
                                        if (value.isBefore(_startDate)) {
                                          return Text(SearchAppLocalizations.of(context).dateErrorMessage).data;
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ]
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        LocationWidget(),
                      ],
                    )
                  ],
                ),
                FlatButton(
                  child: Text(SearchAppLocalizations.of(context).searchButtonText),
                  onPressed: () {
                  if (_formKey.currentState.validate()) {
                    debugPrint(_formResult.toString());
                  setState(() {
                    _formKey.currentState.save();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new ResultsPage(search: _formResult)
                      )
                    );
                  });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  getCatagories(translation, facets) {
    var types = [
      {
        "entityLabel": translation.chapterLabel.toString(),
        "entityId": "chapter"
      },
      {
        "entityLabel": translation.eventLabel.toString(),
        "entityId": "Event"
      },
      //@TODO title name wrong Basic Page, it should be General but then its a hardcoded fix made for now. Will add translated text later
      {
        "entityLabel": 'General',
        "entityId": "page"
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
    var typeCount = {};
    var newtypes = new List();
    for (var facet in facets) {
      if (facet["name"] == "type") {
        for (var filter in facet["values"]) {
          typeCount[filter["filter"]] = filter["count"];
        }
      }
    }

    for (var type in types) {
      if (typeCount[type["entityId"]] != null) {
        newtypes.add({
          "entityLabel": type["entityLabel"] + " (" +
              typeCount[type["entityId"]].toString() + ")",
          "entityId": type["entityId"]
        });
      }
    }

    return newtypes;
  }

   getChapters(chapters, facets) {
     var chapterCount = {};
     var newChapters = new List();
     for (var facet in facets) {
       if (facet["name"] == "field_chapter_reference") {
         for (var filter in facet["values"]) {
           chapterCount[filter["filter"]] = filter["count"];
         }
       }
     }
     for (var chapter in chapters) {
       if (chapterCount[chapter["entityId"]] != null) {
         newChapters.add({
           "entityLabel": chapter["entityLabel"] + " (" +
               chapterCount[chapter["entityId"]].toString() + ")",
           "entityId": chapter["entityId"]
         });
       }
     }
     return newChapters;
   }

   getLanguages(languages) {
     var newLanguages = new List();
     for (var language in languages) {
       newLanguages.add({
         "entityLabel": language["entityLabel"],
         "entityId": language["entityLabel"].split("-")[0]
       });
     }
     return newLanguages;
   }
}
