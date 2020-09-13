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
  civicrmOptionValueJmaQuery(filter: {conditions: [{field: "option_group_id", value: \$value, operator: EQUAL}, {field: "is_active", value: "1", operator: EQUAL}]}, sort: {field: "label", direction: ASC}) {
    entities {
      entityLabel
      entityId
    }
  }
}
""";

final getServiceListingInformationQuery = """
query getContactInformation(\$contact_id: String!, \$contactId: [String]) {
  civicrmContactById(id: \$contact_id) {
    ... on CivicrmContact {
      contactType
      organizationName
      custom896
      custom897
      custom895
      custom893
      custom905
    }
  }
  civicrmAddressJmaQuery(filter: {conditions: {field: "contact_id", value: \$contactId, operator: EQUAL}}) {
    entities {
      ... on CivicrmAddress {
        streetAddress
        city
        stateProvinceId
        geoCode1
        geoCode2
        postalCode
        countryId {
          targetId
        }
      }
    }
  }
  civicrmEmailJmaQuery(filter: {conditions: {field: "contact_id", value: \$contactId, operator: EQUAL}}) {
    entities {
      ... on CivicrmEmail {
        email
      }
    }
  }
  civicrmPhoneJmaQuery(filter: {conditions: {field: "contact_id", value: \$contactId, operator: EQUAL}}) {
    entities {
      ... on CivicrmPhone {
        phone
      }
    }
  }
  civicrmWebsiteJmaQuery(filter: {conditions: {field: "contact_id", value: \$contactId, operator: EQUAL}}) {
    entities {
      ... on CivicrmWebsite {
        url
      }
    }
  }
   civicrmRelationshipJmaQuery(filter: {conditions: [{field: "contact_id_b", value: \$contactId, operator: EQUAL},{field: "relationship_type_id", value: "5", operator: EQUAL}]}) {
    entities { 
      ... on CivicrmRelationship {
        contactIdA {
          ... on FieldCivicrmRelationshipContactIdA {
							entity {
                displayName
                custom895
                custom911
                custom954
                custom953
                custom905
              }
            }
          }
        }
    	}
    }
}
""";

final String taxonomyTermJmaQuery = """
query getTaxonomyOptions(\$language: LanguageId!) {
  taxonomyTermJmaQuery(filter:{conditions: {field: "vid", value: "group", operator: EQUAL}}, limit:100, sort: {field: "name", direction: ASC}) {
    entities(language: \$language) {
      entityLabel
      entityId
    }
  }
}
""";

final String facetsQuery = """
query getSearchResults(\$languages: [String]!, \$fullText: FulltextInput, \$conditionGroup: ConditionGroupInput, \$language: LanguageId!) {
  searchAPISearch(index_id: "default", language: \$languages, condition_group: \$conditionGroup, fulltext: \$fullText, facets: [{field: "type", min_count: 1, limit: 0, operator: "=", missing: false}, {field: "field_chapter_reference", min_count: 1, limit: 0, operator: "=", missing: false}]) {
    facets {
      name
      values {
        filter
        count
      }
    }
   }
    taxonomyTermJmaQuery(filter:{conditions: {field: "vid", value: "group", operator: EQUAL}}, limit:100, sort: {field: "name", direction: ASC}) {
      entities(language: \$language) {
      entityLabel
      entityId
      }
    }
 }
""";

final String query = """
query getSearchResults(\$languages: [String]!, \$fullText: FulltextInput, \$conditionGroup: ConditionGroupInput) {
  searchAPISearch(index_id: "default", language: \$languages, condition_group: \$conditionGroup, fulltext: \$fullText,
   facets: [{field: "type", min_count: 1, limit: 0, operator: "=", missing: false}, {field: "field_chapter_reference", min_count: 1, limit: 0, operator: "=", missing: false}],
   sort: [{field: "search_api_relevance", value: "desc"}, {field: "organization_name", value: "asc"}, {field: "start_date", value: "asc"}]
 ) {
    documents {
      ... on DefaultDoc {
        langcode
        type
        id
        nid
        event_id
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
        field_geolocation_2
        field_geolocation
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
