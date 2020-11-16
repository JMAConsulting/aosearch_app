import 'package:flutter/material.dart';
import 'ui/advanced_search_form.dart';
import 'package:intl/intl.dart';
import 'package:aoapp/l10n/messages_all.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      'Accepting new clients?',
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

  String get categoryTitle {
    return Intl.message(
      'Category',
      name: 'categoryTitle',
      desc: 'categoryTitle',
      locale: localeName,
    );
  }

  String get noResultText {
    return Intl.message(
      'No results found.',
      name: 'noResultText',
      desc: 'noResultText',
      locale: localeName,
    );
  }

  String get basicPageLabel {
    return Intl.message(
      'Basic page',
      name: 'basicPageLabel',
      desc: 'basicPageLabel',
      locale: localeName,
    );
  }

  String get chapterLabel {
    return Intl.message(
      'Chapter',
      name: 'chapterLabel',
      desc: 'chapterLabel',
      locale: localeName,
    );
  }

  String get eventLabel {
    return Intl.message(
      'Event',
      name: 'eventLabel',
      desc: 'eventLabel',
      locale: localeName,
    );
  }

  String get learningResourceLabel {
    return Intl.message(
      'Basic page',
      name: 'learningResourceLabel',
      desc: 'learningResourceLabel',
      locale: localeName,
    );
  }

  String get serviceListingLabel {
    return Intl.message(
      'Service Listing',
      name: 'serviceListingLabel',
      desc: 'serviceListingLabel',
      locale: localeName,
    );
  }

  String get newsLabel {
    return Intl.message(
      'News',
      name: 'newsLabel',
      desc: 'newsLabel',
      locale: localeName,
    );
  }

  String get notAcceptingNewClients {
    return Intl.message(
      'Not accepting new clients',
      name: 'notAcceptingNewClients',
      desc: 'notAcceptingNewClients',
      locale: localeName,
    );
  }

  String get verifiedListing {
    return Intl.message(
      'Verified Listing',
      name: 'verifiedListing',
      desc: 'verifiedListing',
      locale: localeName,
    );
  }

  String get removeAreaTravel {
    return Intl.message(
      'Travels to remote areas',
      name: 'removeAreaTravel',
      desc: 'removeAreaTravel',
      locale: localeName,
    );
  }

  String get nearbyAreaTravel {
    return Intl.message(
      'Travels to nearby areas',
      name: 'nearbyAreaTravel',
      desc: 'nearbyAreaTravel',
      locale: localeName,
    );
  }

  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: 'online',
      locale: localeName,
    );
  }

  String get serviceLegendTitle {
    return Intl.message(
      'Service Listing Legend',
      name: 'serviceLegendTitle',
      desc: 'serviceLegendTitle',
      locale: localeName,
    );
  }

  String get yesText {
    return Intl.message(
      'Yes',
      name: 'yesText',
      desc: 'yesText',
      locale: localeName,
    );
  }

  String get noText {
    return Intl.message(
      'No',
      name: 'noText',
      desc: 'noText',
      locale: localeName,
    );
  }

  String get categoryHintText {
    return Intl.message(
      'Please choose one or more categories',
      name: 'categoryHintText',
      desc: 'categoryHintText',
      locale: localeName,
    );
  }

  String get chapterHintText {
    return Intl.message(
      'Please choose one or more chapters',
      name: 'chapterHintText',
      desc: 'chapterHintText',
      locale: localeName,
    );
  }

  String get eventMapText {
    return Intl.message(
      'View event location on map',
      name: 'eventMapText',
      desc: 'eventMapText',
      locale: localeName,
    );
  }

  String get viewMapText {
    return Intl.message(
      'View on map',
      name: 'viewMapText',
      desc: 'viewMapText',
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,
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
          elevation: 4.0,
          brightness: Brightness.light,
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
