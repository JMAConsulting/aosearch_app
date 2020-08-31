import 'package:flutter/material.dart';
import 'ui/advanced_search_form.dart';
import 'package:intl/intl.dart';
import '../l10n/messages_all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../src/resources/api.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'queries/search_parameters.dart';

class SearchAppLocalizations {
  SearchAppLocalizations(this.localeName);

  static Future<SearchAppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return SearchAppLocalizations(localeName);
    });
  }

  static SearchAppLocalizations of(BuildContext context) {
    return Localizations.of<SearchAppLocalizations>(context, SearchAppLocalizations);
  }

  final String localeName;

  String get keywordHintText {
    return Intl.message(
      'Enter your search term here',
      name: 'keywordHintText',
      desc: 'Keyword hint text',
      locale: localeName,
    );
  }

  String get advSearchTitle {
    return Intl.message(
      'Advanced Search Options',
      name: 'advSearchTitle',
      desc: 'Advanced Search Title text',
      locale: localeName,
    );
  }

  String get acceptingNewClientsTitle {
    return Intl.message(
      'Accepting new Clients?',
      name: 'acceptingNewClientsTitle',
      desc: 'Accepting New Clients title',
      locale: localeName,
    );
  }

  String get chaptersTitle {
    return Intl.message(
      'Chapters',
      name: 'chaptersTitle',
      desc: 'Chapters title',
      locale: localeName,
    );
  }

  String get languagesTitle {
    return Intl.message(
      'Languages',
      name: 'languagesTitle',
      desc: 'LanguagesTitleField',
      locale: localeName,
    );
  }

   String get languagesHintText {
    return Intl.message(
      'Please choose one or more language',
      name: 'languagesHintText',
      desc: 'LanguagesTitleField',
      locale: localeName,
    );
  }

  String get servicesAreProvidedTitle {
    return Intl.message(
      'Services are provided',
      name: 'servicesAreProvidedTitle',
      desc: 'servicesAreProvidedTitleField',
      locale: localeName,
    );
  }

  String get servicesAreProvidedHintText {
    return Intl.message(
      'Please choose where you would like services to be provided',
      name: 'servicesAreProvidedHintText',
      desc: 'servicesAreProvidedHint',
      locale: localeName,
    );
  }

  String get ageGroupsTitleText {
    return Intl.message(
      'Age groups served',
      name: 'ageGroupsTitleText',
      desc: 'ageGroupsTitleText',
      locale: localeName,
    );
  }

  String get ageGroupsHintText {
    return Intl.message(
      'Please choose any appropriate age groups',
      name: 'ageGroupsHintText',
      desc: 'ageGroupsHintText',
      locale: localeName,
    );
  }

  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: 'startDate',
      locale: localeName,
    );
  }

  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: 'endDate',
      locale: localeName,
    );
  }

  String get dateErrorMessage {
    return Intl.message(
      'End Date can\'t be before Start Date',
      name: 'dateErrorMessage',
      desc: 'dateErrorMessage',
      locale: localeName,
    );
  }

  String get searchButtonText {
    return Intl.message(
      'Search',
      name: 'searchButtonText',
      desc: 'searchButtonText',
      locale: localeName,
    );
  }

  String get ownLocationText {
    return Intl.message(
      'Use my location',
      name: 'ownLocationText',
      desc: 'ownLocationText',
      locale: localeName,
    );
  }

  String get keywordText {
    return Intl.message(
      'Fulltext Search',
      name: 'keywordText',
      desc: 'keywordText',
      locale: localeName,
    );
  }

  String get anyText {
    return Intl.message(
      '- Any -',
      name: 'anyText',
      desc: 'anyText',
      locale: localeName,
    );
  }

}

class SearchAppLocalizationsDelegate extends LocalizationsDelegate<SearchAppLocalizations> {
  const SearchAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<SearchAppLocalizations> load(Locale locale) => SearchAppLocalizations.load(locale);

  @override
  bool shouldReload(SearchAppLocalizationsDelegate old) => false;
}

class SearchApp extends StatelessWidget {
  SearchParameters _formResult = SearchParameters();
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      localizationsDelegates: [
        const SearchAppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/AO_logo.png',
                 height: AppBar().preferredSize.height,
                 fit: BoxFit.cover,
              )
            ],
          ),
        ),
        body: new AdvancedSearchForm(),
      )
    );
  }
}
