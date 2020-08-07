import 'package:flutter/material.dart';
import 'advanced_search_form.dart';
import '../queries/variable_container.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (Center(
          child: VariableContainer(child: AdvancedSearchForm()),
        )),
      ),
    );
  }
}

