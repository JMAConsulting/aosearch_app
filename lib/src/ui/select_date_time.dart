import 'package:flutter/material.dart';
import 'dart:async';
import '../queries/state_container.dart';

class SelectDateTime extends StatefulWidget {

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();

}

class _SelectDateTimeState extends State<SelectDateTime> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListTile(
          leading: Icon(Icons.date_range),
          title: Text(
            "${selectedDate.toLocal()}".split(' ')[0]
          ),
          onTap: () {
            _selectDate(context);
          }),
        ),
      );
    }
}

