import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import '../resources/languages.dart';
import 'package:intl/intl.dart';
import '../queries/search_parameters.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'location.dart';
import 'search_results.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../resources/api.dart';

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
  String _acceptingNewClients;


  @override
  Widget build(BuildContext context) {
    debugPrint(Localizations.localeOf(context).languageCode);
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
                labelText: 'Keyword',
              ),
              initialValue: _formResult.keyword,
              validator: (keyword) {
                if (keyword.length < 3) {
                  return 'Keyword is too short';
                }
                return null;
              },
              onSaved: (keyword) {
                _formResult.keyword = keyword;
              },
            ),
            SizedBox(height: 8.0),
            ExpansionTile(
              title: Text(SearchAppLocalizations.of(context).advSearchTitle),
              children: [Column(
                children: [
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
                      return DropDownFormField(
                        value: _acceptingNewClients,
                        titleText: Text(SearchAppLocalizations
                            .of(context)
                            .acceptingNewClientsTitle).data,
                        dataSource: result.data["civicrmOptionValueJmaQuery"]["entities"],
                        valueField: 'entityLabel',
                        textField: 'entityLabel',
                        onChanged: (value) {
                          setState(() {
                            _acceptingNewClients = value;
                          });
                        },
                        onSaved: (value) {
                          _formResult.acceptingNewClients = value;
                        },
                      );
                    }),
                  SizedBox(height: 8.0),
                   Query(
                     options: QueryOptions(
                       documentNode: gql(optionValueQuery),
                       variables: {"value": "languages"},
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
                     }),
                  SizedBox(height: 8.0),
                  MultiSelectFormField(
                    titleText: Text(SearchAppLocalizations.of(context).servicesAreProvidedTitle).data,
                    dataSource: services,
                    valueField: 'value',
                    textField: 'display',
                    hintText: Text(SearchAppLocalizations.of(context).servicesAreProvidedHintText).data,
                    onSaved: (values) {
                      setState(() {
                        _formResult.servicesAreProvided = values;
                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  MultiSelectFormField(
                    titleText: Text(SearchAppLocalizations.of(context).ageGroupsTitleText).data,
                    dataSource: ageGroups,
                    valueField: 'value',
                    textField: 'display',
                    hintText: Text(SearchAppLocalizations.of(context).ageGroupsHintText).data,
                    onSaved: (values) {
                      setState(() {
                        _formResult.ageGroupsServed = values;
                      });
                    },
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
              )],
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new ResultsPage(search: _formResult)
                    )
                  );
                }
              },
            )
          ],
        ),
      ),
        ),
    );
  }

  getOptions(String $optionGroupId, String $widgetType) {
    Query(
      options: QueryOptions(
        documentNode: gql(optionValueQuery),
        variables: {"value": $optionGroupId},
      ),
      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
        debugPrint(result.toString());
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.loading) {
          return Text('Loading');
        }
        // it can be either Map or List
//        var repositories = result.data['civicrmOptionValueQuery']['entities'];
//        var options = new Map();
//        repositories.forEach((content, index) {
//          options[content['entityLabel']] = content['entityLabel'];
//        });
//        return options;
      }
    );
  }
}

