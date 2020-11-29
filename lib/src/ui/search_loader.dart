import 'package:aoapp/src/search_app.dart';
import 'package:flutter/material.dart';
import 'advanced_search_form.dart';
import 'package:aoapp/src/queries/search_parameters.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:aoapp/src/resources/api.dart';

class SearchLoader extends StatelessWidget {
  SearchParameters _formResult = SearchParameters();
  @override
  Widget build(BuildContext context) {
    final translation = SearchAppLocalizations.of(context);
    final loadIndicator = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(171, 173, 0, 100),
              strokeWidth: 5,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(height: 20),
          Text("Please Wait....",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                fontSize: 20),
          )
        ]
    );
    return Center(
      child: GraphQLProvider(
          client: Localizations.localeOf(context).languageCode == 'en' ? client : frenchClient,
          child: Query(
            options: QueryOptions(
              documentNode: gql(facetsQuery),
              variables: queryVariables(
                  Localizations.localeOf(context).languageCode,
                  _formResult.ageGroupsServed,
                  _formResult.acceptingNewClients,
                  _formResult.servicesAreProvided,
                  _formResult.keyword,
                  _formResult.languages,
                  _formResult.chapters,
                  _formResult.catagories,
                  Localizations.localeOf(context).languageCode.toUpperCase(),
                  _formResult.isVerified,
                  _formResult.startDate,
                  _formResult.endDate,
                  true
              ),
            ),
            builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.loading) {
                return Center(child: loadIndicator);
              }
              else if (!result.data["searchAPISearch"].isEmpty) {
                _formResult.catagories = getCatagories(translation, result.data["searchAPISearch"]["facets"], false);
                _formResult.chapters = getChapters(result.data["taxonomyTermJmaQuery"]["entities"], result.data["searchAPISearch"]["facets"]);
              }

              return  Query(
                options: QueryOptions(
                  documentNode: gql(optionValueQuery),
                  variables: {"value": "105"},
                ),
                builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.loading) {
                    return Center(child: loadIndicator);
                  }
                  else if (!result.data["civicrmOptionValueJmaQuery"].isEmpty) {
                    _formResult.languages = getLanguages(result.data["civicrmOptionValueJmaQuery"]["entities"]);
                  }
                  return Query(
                      options: QueryOptions(
                        documentNode: gql(optionValueQuery),
                        variables: {"value": "232"},
                      ),
                      builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                        if (result.loading) {
                          return Center(child: loadIndicator);
                        }
                        else if (!result.data["civicrmOptionValueJmaQuery"].isEmpty) {
                          _formResult.servicesAreProvided = result.data["civicrmOptionValueJmaQuery"]["entities"];
                        }
                        return new AdvancedSearchForm(_formResult);
                      }
                  );
                }
              );
            },
          )
      )
    );
  }

  getLanguages(languages) {
    var newLanguages = new List();
    for (var language in languages) {
      newLanguages.add({
        "entityLabel": language["entityLabel"],
        "entityId": language["entityLabel"].split("-")[0]
      });
    }
    return newLanguages;
  }

  getChapters(chapters, facets) {
    var chapterCount = {};
    var newChapters = new List();
    for (var facet in facets) {
      if (facet["name"] == "field_chapter_reference") {
        for (var filter in facet["values"]) {
          chapterCount[filter["filter"]] = filter["count"];
        }
      }
    }
    for (var chapter in chapters) {
      if (chapterCount[chapter["entityId"]] != null) {
        newChapters.add({
          "entityLabel": chapter["entityLabel"] + " (" +
              chapterCount[chapter["entityId"]].toString() + ")",
          "entityId": chapter["entityId"]
        });
      }
    }
    return newChapters;
  }

  getCatagories(translation, facets, pending) {
    var types = [
      {
        "entityLabel": translation.chapterLabel.toString(),
        "entityId": "chapter"
      },
      {
        "entityLabel": translation.eventLabel.toString(),
        "entityId": "Event"
      },
      {
        "entityLabel": translation.basicPageLabel.toString(),
        "entityId": "page"
      },
      {
        "entityLabel": translation.learningResourceLabel.toString(),
        "entityId": "learning_resource"
      },
      {
        "entityLabel": translation.newsLabel.toString(),
        "entityId": "article"
      },
      {
        "entityLabel": translation.serviceListingLabel.toString(),
        "entityId": "Service Listing"
      }
    ];
    // Return all categories without a count if we haven't gotten any results from upstream yet.
    if (pending) {
      return types;
    }
    var typeCount = {};
    var newtypes = new List();
    for (var facet in facets) {
      if (facet["name"] == "type") {
        for (var filter in facet["values"]) {
          typeCount[filter["filter"]] = filter["count"];
        }
      }
    }

    for (var type in types) {
      if (typeCount[type["entityId"]] != null) {
        newtypes.add({
          "entityLabel": type["entityLabel"] + " (" +
              typeCount[type["entityId"]].toString() + ")",
          "entityId": type["entityId"]
        });
      }
    }

    return newtypes;
  }
}
