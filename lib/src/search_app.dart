import 'package:flutter/material.dart';
import 'ui/advanced_search_form.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import '../l10n/messages_all.dart';

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

  String get languagesTitle {
    return Intl.message(
      'Languages',
      name: 'languagesTitle',
      desc: 'LanguagesTitleField',
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
    return MaterialApp(
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
      ),
    );
  }
}
