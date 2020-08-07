import 'package:flutter/material.dart';
import 'query.dart';

class _InheritedVariableContainer extends InheritedWidget {

  final VariableContainerState data;

  _InheritedVariableContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key : key, child : child);

  @override
  bool updateShouldNotify(_InheritedVariableContainer) => true;
}

class VariableContainer extends StatefulWidget {

  final Widget child;
  final Query query;

  VariableContainer({
    @required this.child,
    this.query
});

  static VariableContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedVariableContainer>().data;
  }
  @override
  VariableContainerState createState() {
    return VariableContainerState();
  }
}

class VariableContainerState extends State<VariableContainer> {
  Query _query;

  Query get query {
    return _query;
  }
  void updateKeyword(String keyword) {
    setState(() {
      _query.keyword = keyword;
    });
  }
  void updateLanguages(String languages) {
    setState(() {
      _query.languages = languages;
    });
  }
  void updateAcceptingNewClients(String acceptingNewClients) {
    setState(() {
      _query.acceptingNewClients = acceptingNewClients;
    });
  }
  void updateStartDate(DateTime startDate) {
    setState(() {
      _query.startDate = startDate;
    });
  }
  void updateEndDate(DateTime endDate) {
    setState(() {
      _query.endDate = endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedVariableContainer(
        data: this,
        child: widget.child,
    );
  }
}
