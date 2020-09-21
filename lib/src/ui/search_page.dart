import 'package:flutter/material.dart';
import 'package:aoapp/src/ui/advanced_search_form.dart';

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
