import 'package:aoapp/src/resources/languages.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../queries/search_parameters.dart';
import '../resources/api.dart';
import 'package:html/parser.dart';

class ResultsPage extends StatelessWidget {
  final SearchParameters search;
  ResultsPage({@required this.search});

  @override
  Widget build(BuildContext context) {
    print("Building ResultsPage");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: SafeArea(
        child: Center(
          child: Container(
          height: 100,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/AO_logo.png'),
              fit: BoxFit.fitHeight)),
             ),
        ),
        ),
      ),
      body: new SearchResults(search: search),
    );
  }
}


class SearchResults extends StatefulWidget {
  final SearchParameters search;
  SearchResults({Key key, @required this.search}): super(key:key);

  @override
  _SearchResultsState createState() => _SearchResultsState(search);
}

class _SearchResultsState extends State<SearchResults> {
  final SearchParameters search;
  var appLanguage = 'en';
  var type = 'Service Listing';
  _SearchResultsState(this.search);

  @override
  Widget build(BuildContext context) {
    print('Building SearchResults');
    return Query(
      options: QueryOptions(
        documentNode: gql(query),
        variables: queryVariables(
            Localizations.localeOf(context).languageCode,
            type,
            search.ageGroupsServed,
            search.acceptingNewClients,
            search.servicesAreProvided,
            search.keyword,
            search.languages,
        ),
      ),
      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
        return SafeArea(
          child: Center(
            child: result.hasException
                ? Text(result.exception.toString())
                : result.loading
                ? CircularProgressIndicator()
                : Result(list: result.data),
          ),
        );
      },
    );
  }

  queryVariables(appLanguage, types, ageGroupsServed, acceptingNewClients,
      servicesProvided, keywords, languages) {
    var conditionGroupGroups = new List();
    if (ageGroupsServed != null) {
      conditionGroupGroups.add(buildConditionGroup({"custom_898": ageGroupsServed.join(',')}, "OR", false));
    }
    if (types != null) {
      conditionGroupGroups.add(
          buildConditionGroup({"type": types ?? ''}, "OR", false));
    }
    if (acceptingNewClients != null && acceptingNewClients != 'Any') {
      conditionGroupGroups.add(
          buildConditionGroup({"custom_896": "Accepting new clients"}, "OR",
              acceptingNewClients == "Yes" ? false : true));
    }
    if (servicesProvided != null) {
      conditionGroupGroups.add(
          buildConditionGroup({"custom_897": servicesProvided.join(',')}, "OR", false));
    }
    if (languages != null) {
      conditionGroupGroups.add(
        buildConditionGroup({"custom_899": languages.join(',')}, "OR", false)
      );
    }
    var conditionGroup = {
      "conjunction": "AND",
      'groups': conditionGroupGroups,
    };
    var variables = {
      "conditions": [],
      "languages": [appLanguage, "und"],
      'conditionGroup': conditionGroup,
      'fulltext': keywords,
    };
    debugPrint(variables.toString());
    return variables;
  }
}

class Result extends StatelessWidget {
  Result({@required this.list});
  final list;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list["searchAPISearch"]["documents"].length,
        itemBuilder: (BuildContext context, int index) {
          final item = list["searchAPISearch"]["documents"][index];
          return ListTile(
            onTap: () {},
            title: Container(
              padding: EdgeInsets.all(5.0),
              height: 35.0,
              child: Text(
                getTitle(item),
                style: TextStyle(
                  color: Colors.grey[850],
                  fontSize: 18.0
                ),
              ),
            ),
            subtitle: Text(
              getDescription(item),
            ),
            trailing: Icon(Icons.arrow_right),
            contentPadding: EdgeInsets.symmetric(vertical: 3.5),
          );
        });
  }

  getTitle(item) {
    var title = item['title'] ?? item["organization_name"] ?? '';
    title = title.replaceAll('Self-employed ', '');
    return title;
  }

  String getDescription(item) {
    var body = parse(item['custom_893'] ?? item['description'] ?? item['body'] ?? '');
    return truncateWithEllipsis(200, parse(body.body.text).documentElement.text);
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}