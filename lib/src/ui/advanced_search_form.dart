import 'package:flutter/material.dart';
import '../queries/state_container.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AdvancedSearchForm extends StatefulWidget {
  @override
  _AdvancedSearchFormState createState() {
    return _AdvancedSearchFormState();
  }
}

class _AdvancedSearchFormState extends State<AdvancedSearchForm> {

  get container => StateContainer.of(context);
  final _formKey = GlobalKey<FormState>();
  String keyword;
  String languages = 'English';
  String acceptingNewClients = 'Any';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your search term here',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.search),
                    )
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Language'
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all()
                          ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                value: languages,
                                icon: Icon(Icons.keyboard_arrow_down),
                                onChanged: (String newValue) {
                                  setState(() {
                                    languages = newValue;
                                  });
                                },
                                items: <String>[
                                  // function returns these
                                  'English',
                                  'French',
                                  'German'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Accepting New Clients'
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all()
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              value: acceptingNewClients,
                              icon: Icon(Icons.keyboard_arrow_down),
                              onChanged: (String newValue) {
                                setState(() {
                                  acceptingNewClients = newValue;
                                });
                              },
                              items: <String> [
                                'Any',
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String> (
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: DateTimeField(
                      format: dateFormat,
                      initialValue: DateTime.now(),
                      onShowPicker: (context, value) {
                        return showDatePicker(
                            context: context,
                            initialDate: value ?? DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(DateTime.now().year + 5)
                        );
                      },
                      onChanged: (date) {
                        setState(() {
                          startDate = date;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: DateTimeField(
                      format: dateFormat,
                      initialValue: DateTime.now(),
                      onShowPicker: (context, value) {
                        return showDatePicker(
                            context: context,
                            initialDate: value ?? DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(DateTime.now().year + 5)
                        );
                      },
                      onChanged: (date) {
                        setState(() {
                          endDate = date;
                        });
                      }),
                    )
                ],
              )
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // this is where we would pass the information from the form to the server
                container.updateQuery(keyword, languages, acceptingNewClients, startDate, endDate);
                print(container.getQuery());
              }
            },
            child: Text('Search'),
          )
        ],
      ),
    );
  }
}

