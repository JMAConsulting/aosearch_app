import 'package:aoapp/src/queries/variable_container.dart';
import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  List<String> _dropDownValues;
  String _queryProperty;
  String _title;

  DropDownField(
      List<String> dropDownValues, String queryProperty, String title) {
    _dropDownValues = dropDownValues;
    _queryProperty = queryProperty;
    _title = title;
  }
  @override
  _DropDownFieldState createState() =>
      _DropDownFieldState(_dropDownValues, _queryProperty, _title);
}

class _DropDownFieldState extends State<DropDownField> {
  get container {
    return VariableContainer.of(context);
  }

  List<String> _dropDownValues;
  String _dropDownSelection;
  String _queryProperty;
  String _title;

  _DropDownFieldState(
      List<String> dropDownValues, String queryProperty, String title) {
    _dropDownValues = dropDownValues;
    _dropDownSelection = dropDownValues[0];
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
            child: Container(
              child: Text(_title),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  value: _dropDownSelection,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onChanged: (String newValue) {
                    setState(() {
                      _dropDownSelection = newValue;
                      container._queryProperty = _dropDownSelection;
                    });
                  },
                  items: _dropDownValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
