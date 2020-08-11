import 'package:flutter/material.dart';
import '../queries/state_container.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'keyword_field.dart';
import 'dropdown_field.dart';
import 'multiselect_field.dart';

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
  String languages;
  KeywordField keywordField = new KeywordField();

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
                title: keywordField
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
                    child: MultiSelectField(
                      [
                        {
                          "display": "English",
                          "value": "English",
                        },
                        {
                          "display": "French",
                          "value": "French",
                        },
                        {
                          "display": "Arabic",
                          "value": "Arabic",
                        },
                      ],
                      "updateAcceptingNewClients",
                      "Languages"
                    ),
                  ),
                  Expanded(
                    child: DropDownField(['Any', 'Yes', 'No'], "updateAcceptingNewClients", 'Accepting New Clients')
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
