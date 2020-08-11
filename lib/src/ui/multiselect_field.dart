import 'package:aoapp/src/queries/variable_container.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';


class MultiSelectField extends StatefulWidget {
  List _dropDownValues;
  String _queryProperty;
  String _title;

  MultiSelectField (List dropDownValues, String queryProperty, String title) {
    _dropDownValues = dropDownValues;
    _queryProperty = queryProperty;
    _title = title;
  }

  @override
  _MultiSelectFieldState createState() => _MultiSelectFieldState(_dropDownValues, _queryProperty, _title);
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  get container {
    return VariableContainer.of(context);
  }
  List _dropDownValues;
  String _dropDownSelection;
  String _queryProperty;
  String _title;

  _MultiSelectFieldState (List dropDownValues, String queryProperty, String title) {
    _dropDownValues = dropDownValues;
    _dropDownSelection = dropDownValues[0].toString();
    _queryProperty = queryProperty;
    _title = title;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: MultiSelectFormField(
              autovalidate: false,
              titleText: _title,
              validator: (value) {
                if (value == null || value.length == 0) {
                  return 'Please select one or more languages';
                }
              },
              dataSource: _dropDownValues,
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              hintText: 'Please choose one or more',
              initialValue: [],
            ),
          )
        ],
      ),
    );
  }
}
