import 'package:flutter/material.dart';
import 'advanced_search_form.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (Center(
          child: AdvancedSearchForm(),
        )),
      ),
    );
  }
}

// these lists are just dummy lists for testing purposes

