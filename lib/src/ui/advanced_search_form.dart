import 'package:flutter/material.dart';
import '../queries/state_container.dart';
import 'package:intl/intl.dart';
import 'keyword_field.dart';
import 'dropdown_field.dart';


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
  KeywordField keywordField = new KeywordField();
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
                alignment: Alignment.bottomCenter, child: keywordField),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: DropDownField(['English', 'French', 'German'],
                          'updateLanguages', "Languages")),
                  Expanded(
                      child: DropDownField(['Any', 'Yes', 'No'],
                          "updateAcceptingNewClients", 'Accepting New Clients'))
                ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // this is where we would pass the information from the form to the server
                container.updateQuery(keyword, languages, acceptingNewClients,
                    startDate, endDate);
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
