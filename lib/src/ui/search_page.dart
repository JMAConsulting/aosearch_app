import 'package:flutter/material.dart';
import 'advanced_search_form.dart';
import '../queries/variable_container.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aoapp/api.dart';

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

class SearchResult extends StatefulWidget {
  SearchResult({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var acceptingNewClients = "Yes";
  var servicesProvided = "At work address";
  var ageGroup = "Preschool";
  var type = "learning_resource";
  var appLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          documentNode: gql(query),
          variables: queryVariables(appLanguage, type, servicesProvided,
              ageGroup, acceptingNewClients)
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          return Scaffold(
              appBar: AppBar(
                title: Text("TODO App With GraphQL"),
              ),
              body: Center(
                child: result.hasException
                    ? Text(result.exception.toString())
                    : result.loading,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  refetch();
                },
                tooltip: 'New Task',
                child: Icon(Icons.add),
              ));
        });
  }

  queryVariables(language, types, servicesProvided, ageGroupsServed,
    acceptingNewClients) {
    var conditionGroupGroups = new List();
    conditionGroupGroups.add(buildConditionGroup({"type": types}, "OR"));
    var conditionGroup = {
      "conjunction": "AND",
      'groups': conditionGroupGroups,
    };
    var variables = {
      "conditions": [],
      "languages": [language, "und"],
      'conditionGroup': conditionGroup,
    };
    return variables;
  }
}
