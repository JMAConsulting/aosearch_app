import 'package:flutter/material.dart';
import '../resources/languages.dart';
import 'package:intl/intl.dart';
import '../queries/query.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';


class AdvancedSearchForm extends StatefulWidget {
  @override
  _AdvancedSearchFormState createState() {
    return _AdvancedSearchFormState();
  }
}

class _AdvancedSearchFormState extends State<AdvancedSearchForm> {
  Query _formResult = Query();
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _startDate;
  String _acceptingNewClients;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your search term here',
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
            DropDownFormField(
              value: _acceptingNewClients,
              titleText: 'Accepting new Clients?',
              dataSource: acceptingNewClients,
              valueField: 'value',
              textField: 'display',
              onChanged: (value) {
                setState(() {
                  _acceptingNewClients = value;
                });
              },
              onSaved: (value) {
                _formResult.acceptingNewClients = value;
              },
            ),
            SizedBox(height: 8.0),
            MultiSelectFormField(
              titleText: 'Languages',
              validator: (value) {
                if (value == null || value.length == 0) {
                  return "Please select more items";
                }
                return null;
              },
              dataSource: language,
              valueField: 'value',
              textField: 'display',
              hintText: 'Please choose one or more languages',
              onSaved: (values) {
                setState(() {
                  _formResult.languages = values;
                });
              },
            ),
            SizedBox(height: 8.0),
            MultiSelectFormField(
              titleText: 'Services are provided',
              dataSource: services,
              valueField: 'value',
              textField: 'display',
              hintText: 'Please choose where you would like services to be provided',
              onSaved: (values) {
                setState(() {
                  _formResult.servicesAreProvided = values;
                });
              },
            ),
            SizedBox(height: 8.0),
            MultiSelectFormField(
              titleText: 'Age groups served',
              dataSource: ageGroups,
              valueField: 'value',
              textField: 'display',
              hintText: 'Please choose any appropriate age groups',
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
                    Text('Start Date'),
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
                      Text('End Date'),
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
                                return "End Date can't be before Start Date";
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
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // TODO: @Monish please add your call here on _formResult
                  print(_formResult);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
