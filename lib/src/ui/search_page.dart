import 'package:flutter/material.dart';
import 'package:aoapp/src/ui/advanced_search_form.dart';
import 'package:aoapp/src/queries/search_parameters.dart';

class SearchPage extends StatelessWidget {
  SearchParameters _formResult = SearchParameters();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (Center(
          child: AdvancedSearchForm(_formResult),
        )),
      ),
    );
  }
}
