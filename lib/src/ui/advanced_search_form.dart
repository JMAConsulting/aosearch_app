import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';
import '../queries/search_parameters.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'location.dart';
import 'search_results.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../resources/api.dart';
import '../resources/chapters.dart';

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
  DateTime _startDate;

  @override
  Widget build(BuildContext context) {
    final translation = SearchAppLocalizations.of(context);
    if (_formResult.locale != Localizations.localeOf(context).languageCode) {
      setState(() {
        _formResult.acceptingNewClients = '';
        _formResult.locale = Localizations.localeOf(context).languageCode;
      });
    }
    const rowSpacer=TableRow(
      children: [
        SizedBox(
         height: 18,
        ),
        SizedBox(
         height: 18,
        )
      ]);
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
                  decoration: InputDecoration(
                    hintText: Text(SearchAppLocalizations.of(context).keywordHintText).data,
                    labelText: Text(SearchAppLocalizations.of(context).keywordText).data,
                  ),
                  initialValue: _formResult.keyword,
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
                            Localizations.localeOf(context).languageCode.toUpperCase()
                            ),
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
                                    .categoryTitle).data,
                                dataSource: getCatagories(translation, result.data["searchAPISearch"]["facets"]),
                                valueField: 'entityId',
                                textField: 'entityLabel',
                                onSaved: (values) {
                                  _formResult.catagories = values;
                                  /*
                                  setState(() {
                                    _formResult.catagories = values;
                                  });

                                   */
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
                                Localizations.localeOf(context).languageCode.toUpperCase()
                            ),
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
                                .chaptersTitle).data,
                              dataSource: getChapters(result.data["taxonomyTermJmaQuery"]["entities"], result.data["searchAPISearch"]["facets"]),
                              valueField: 'entityId',
                              textField: 'entityLabel',
                              onSaved: (values) {
                                _formResult.chapters = values;
                                /*
                                setState(() {
                                  _formResult.chapters = values;
                                });

                                 */
                              },
                            );
                          }
                        ),
                        Query(
                          options: QueryOptions(
                            documentNode: gql(optionValueQuery),
                            variables: {"value": "195"},
                          ),
                          builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.loading) {
                              return Text('Loading');
                            }
                            var options = new List();
                            options.add({"entityLabel": Text(SearchAppLocalizations.of(context).anyText).data});
                            for (var item in result.data["civicrmOptionValueJmaQuery"]["entities"]) {
                              options.add(item);
                            }
                            return DropDownFormField(
                              value: _formResult.acceptingNewClients,
                              titleText: Text(SearchAppLocalizations
                                .of(context)
                                .acceptingNewClientsTitle).data,
                              dataSource: options,
                              valueField: 'entityLabel',
                              textField: 'entityLabel',
                              onChanged: (value) {
                                setState(() {
                                  _formResult.acceptingNewClients = value;
                                });
                              },
                              onSaved: (value) {
                                _formResult.acceptingNewClients = value;
                              },
                            );
                          }
                        ),
                        SizedBox(height: 8.0),
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
                              dataSource: result.data["civicrmOptionValueJmaQuery"]["entities"],
                              valueField: 'entityLabel',
                              textField: 'entityLabel',
                              hintText: Text(SearchAppLocalizations.of(context).languagesHintText).data,
                              onSaved: (values) {
                                setState(() {
                                  _formResult.languages = values;
                                });
                              },
                            );
                          }
                        ),
                        SizedBox(height: 8.0),
                        Query(
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
                                setState(() {
                                  _formResult.servicesAreProvided = values;
                                });
                              },
                            );
                          }
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
                                setState(() {
                                  _formResult.ageGroupsServed = values;
                                });
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
                                      if (value != null) {
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
      {
        "entityLabel": translation.learningResourceLabel.toString(),
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
    List<Map<String, dynamic>> newtypes = [];
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
     List<Map<String, dynamic>> newChapters = [];
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

  queryVariables(appLanguage, ageGroupsServed, acceptingNewClients,
      servicesProvided, keywords, languages, chapters, categories, lang) {
    var conditionGroupGroups = new List();
    acceptingNewClients = acceptingNewClients == null ? '- Any -' : acceptingNewClients;
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
      "language": lang,
    };
    if (keywords != null && keywords.length > 0) {
      variables['fullText'] = {"keys": keywords};
      variables['conditionGroup'] = new List();
    }
    return variables;
  }
}
