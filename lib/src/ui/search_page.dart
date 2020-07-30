import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (Center(
          child: (Card(
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 55.0),
            child: FlatButton(
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              child: ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Search',
                    style: TextStyle(
                        fontSize: 22.0
                    ),
                  )
              ),
            ),
          )),
        )),
      ),
    );
  }
}

// these lists are just dummy lists for testing purposes
List recentSearches = [
  'Test 1',
  'Test 2',
  'Absolute Test'
];
List serviceListings = [
  'area',
  'book',
  'business',
  'case',
  'child',
  'company',
  'country',
  'job',
  'month',
  'Test 1',
  'Test 2',
  'Absolute Test'
];
List searchResults = [];

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query = '';
          },
          icon: Icon(Icons.clear,)
      ),
    ];
  }
  String result;
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResults.add(query);
    if (result == null) {
      result = query;
    }
    return Center(
      child: Container(
        height: 100.0,
        width: 120.0,
        child: Card(
          color: Colors.green,
          shape: StadiumBorder(),
          child: Center(
            child: Text(
              result,
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty?recentSearches:serviceListings.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: (){
            result = suggestionList[index];
            showResults(context);
          },
          leading: Icon(
            Icons.people,
            color: Colors.blue,
          ),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ]
            ),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }

}
