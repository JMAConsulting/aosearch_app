import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';

final HttpLink _httpLink = HttpLink(
  uri: 'https://jma.staging.autismontario.com/graphql',
);

final HttpLink _frenchHttpLink = HttpLink(
  uri: 'https://jma.staging.autismontario.com/fr/graphql',
);

final AuthLink _authLink = AuthLink(
  getToken: () async => '',
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: _authLink.concat(_httpLink),
  ),
);

ValueNotifier<GraphQLClient> frenchClient = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: _authLink.concat(_frenchHttpLink),
  ),
);

final String optionValueQuery = """
query getOptionValues(\$value: [String]!) {
  civicrmOptionValueJmaQuery(filter: {conditions: [{field: "option_group_id", value: \$value, operator: EQUAL}, {field: "is_active", value: "1", operator: EQUAL}]}) {
    entities {
      entityLabel
      entityId
    }
  }
}
""";

final String query = """
query getSearchResults(\$languages: [String]!, \$fullText: FulltextInput, \$conditionGroup: ConditionGroupInput) {
  searchAPISearch(index_id: "default", language: \$languages, condition_group: \$conditionGroup, fulltext: \$fullText, facets: [{field: "type", min_count: 1, limit: 0, operator: "=", missing: false}, {field: "field_chapter_reference", min_count: 1, limit: 0, operator: "=", missing: false}]) {
    documents {
      ... on DefaultDoc {
        type
        title
        tm_x3b_und_title_1
        description
        custom_356
        custom_891
        custom_893
        organization_name
        custom_892
        custom_895
        custom_896
        custom_897
        custom_898
        custom_899
        custom_912
        custom_911
        custom_904
        field_chapter_reference
        body
      }
    }
    facets {
      name
      values {
        filter
        count
      }
    }
  }
}
""";

queryVariable(String $value, String $name, $negative) =>
    {"name": $name, "value": $value, "operator": $negative ? "<>" : "="};

buildConditionGroup(Map $queryConditions, String $conjunction, bool $negative) {
  var conditions = new List();
  $queryConditions.forEach((key, value) {
    var valueConditions = value.split(',');
    valueConditions.forEach((v) {
      if (v.contains(',')) {
        v.replace(',', '');
      }
      v.trim();
      conditions.add(queryVariable(v, key, $negative));
    });
  });
  var conditionGroup = {
    "conjunction": $conjunction,
    "conditions": conditions,
  };
  return conditionGroup;
}