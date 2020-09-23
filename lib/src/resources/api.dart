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

final getPrimaryContactQuery = """
query getContactInformation(\$contact_id: [String]) {
    civicrmEmailJmaQuery(filter: {conditions: {field: "contact_id", value: \$contact_id, operator: EQUAL}}) {
    entities {
      ... on CivicrmEmail {
        email
      }
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
      custom898Jma
      custom897Jma
      custom895
      custom893
      custom905
      custom899Jma
      custom911
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
   civicrmRelationshipJmaQuery(filter: {conditions: {field: "contact_id_b", value: \$contactId, operator: EQUAL}}) {
    entities { 
      ... on CivicrmRelationship {
        relationshipTypeId
        contactIdA {
          ... on FieldCivicrmRelationshipContactIdA {
							entity {
							  entityId
                displayName
                custom895
                custom911
                custom954Jma
                custom953Jma
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

queryVariables(appLanguage, ageGroupsServed, acceptingNewClients,
    servicesProvided, keywords, languages, chapters, categories, lang,
    isvVerified, startDate, endDate, facets) {
  var conditionGroupGroups = new List();
  if (ageGroupsServed != null && !ageGroupsServed.isEmpty) {
    conditionGroupGroups.add(buildConditionGroup(
        {"custom_898": ageGroupsServed.join(',')}, "OR", false));
  }
  if (categories != null && !categories.isEmpty) {
    conditionGroupGroups.add(
        buildConditionGroup({"type": categories.join(',')}, "OR", false));
  }
  if (chapters != null && !chapters.isEmpty) {
    conditionGroupGroups.add(
        buildConditionGroup(
            {"field_chapter_reference": chapters.join(',')}, "OR", false));
  }
  if (acceptingNewClients != null && acceptingNewClients != '- Any -'
      && acceptingNewClients != '- Toutes -') {
    conditionGroupGroups.add(
        buildConditionGroup({"custom_896": "Accepting new clients"}, "OR",
            acceptingNewClients == "Yes" || acceptingNewClients == "Oui" ? false : true));
  }
  if (servicesProvided != null && !servicesProvided.isEmpty) {
    conditionGroupGroups.add(
        buildConditionGroup({"custom_897": servicesProvided.join(',')}, "OR", false));
  }
  if (languages != null && !languages.isEmpty) {
    conditionGroupGroups.add(
        buildConditionGroup({"custom_899": languages.join(',')}, "OR", false)
    );
  }
  if (isvVerified == true || isvVerified == false) {
    var op = isvVerified == true ? '<>' : '=';
    conditionGroupGroups.add(
        buildConditionGroup({"type": "Service Listing"}, "AND", false));
    conditionGroupGroups.add(
        {
          "conjunction": "AND",
          "conditions": [
            {"name": "custom_911", "value": 'None', "operator": op}
          ],
        }
    );
    conditionGroupGroups.add(
        {
          "conjunction": "OR",
          "conditions": [
            {"name": "custom_895", "value": null, "operator": op},
            {"name": "custom_911", "value": null, "operator": op}
          ],
        }
    );
  }

  if (startDate != null) {
    conditionGroupGroups.add(
        {
          "conjunction": "AND",
          "conditions": [
            {"name": "custom_891", "value": startDate.millisecondsSinceEpoch, "operator": ">="}
          ]
        }
    );
  }
  if (endDate != null) {
    conditionGroupGroups.add(
        {
          "conjunction": "AND",
          "conditions": [
            {"name": "custom_892", "value": endDate.millisecondsSinceEpoch, "operator": "<="}
          ]
        }
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
  };
  if (keywords != null && keywords.length > 0) {
    variables['fullText'] = {"keys": keywords};
  }
  if (facets) {
    variables['language'] = lang;
  }
  return variables;
}
