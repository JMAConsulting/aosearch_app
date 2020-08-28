// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "acceptingNewClientsTitle" : MessageLookupByLibrary.simpleMessage("Accepting new Clients?"),
    "advSearchTitle" : MessageLookupByLibrary.simpleMessage("Advanced Search Options"),
    "ageGroupsHintText" : MessageLookupByLibrary.simpleMessage("Please choose any appropriate age groups"),
    "ageGroupsTitleText" : MessageLookupByLibrary.simpleMessage("Age groups served"),
    "dateErrorMessage" : MessageLookupByLibrary.simpleMessage("End Date can\'t be before Start Date"),
    "endDate" : MessageLookupByLibrary.simpleMessage("End Date"),
    "keywordHintText" : MessageLookupByLibrary.simpleMessage("Enter your search term here"),
    "languagesHintText" : MessageLookupByLibrary.simpleMessage("Please choose one or more language"),
    "languagesTitle" : MessageLookupByLibrary.simpleMessage("Languages"),
    "servicesAreProvidedHintText" : MessageLookupByLibrary.simpleMessage("Please choose where you would like services to be provided"),
    "servicesAreProvidedTitle" : MessageLookupByLibrary.simpleMessage("Services are provided"),
    "startDate" : MessageLookupByLibrary.simpleMessage("Start Date")
  };
}
