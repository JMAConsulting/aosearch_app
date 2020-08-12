import 'package:aoapp/src/queries/variable_container.dart';
import 'package:flutter/material.dart';

class KeywordField extends StatefulWidget {
  @override
  _KeywordFieldState createState() => _KeywordFieldState();
}

class _KeywordFieldState extends State<KeywordField> {
  get container {
    return VariableContainer.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          container.updateQuery(value);
        });
      },
      decoration: InputDecoration(
          hintText: 'Enter your search term here',
          prefixIcon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          )),
    );
  }
}
