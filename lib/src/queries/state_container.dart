import 'package:flutter/cupertino.dart';
import 'query.dart';

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final Query query;

  StateContainer({@required this.child, this.query});

  static StateContainerState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()
        .data;
  }

  @override
  StateContainerState createState() {
    return new StateContainerState();
  }
}

class StateContainerState extends State<StateContainer> {
  Query _query;

  Query get query {
    return _query;
  }

  void updateQuery(String keyword, String languages, String acceptingNewClients,
      DateTime startDate, DateTime endDate) {
    if (_query == null) {
      _query = new Query(
          keyword, languages, acceptingNewClients, startDate, endDate);
      setState(() {
        _query = _query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
