import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';
import 'Languages/english.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    // 'en': english(),
    'en': english(),
  };

  String get fastFood {
    return _localizedValues[locale.languageCode]['fastFood'];
  }

  String get anytimeSoon {
    return _localizedValues[locale.languageCode]['anytimeSoon'];
  }

  String get served {
    return _localizedValues[locale.languageCode]['served'];
  }

  String get seaFood {
    return _localizedValues[locale.languageCode]['seaFood'];
  }

  String get chinesee {
    return _localizedValues[locale.languageCode]['chinesee'];
  }

  String get dessert {
    return _localizedValues[locale.languageCode]['dessert'];
  }

  String get tableNo {
    return _localizedValues[locale.languageCode]['tableNo'];
  }

  String get totalAmount {
    return _localizedValues[locale.languageCode]['totalAmount'];
  }

  String get finishOrdering {
    return _localizedValues[locale.languageCode]['finishOrdering'];
  }

  String get mergeOrdering {
    return _localizedValues[locale.languageCode]['mergeOrdering'];
  }

  String get searchItem {
    return _localizedValues[locale.languageCode]['searchItem'];
  }

  String get itemsInCart {
    return _localizedValues[locale.languageCode]['itemsInCart'];
  }

  String get weMustSay {
    return _localizedValues[locale.languageCode]['weMustSay'];
  }

  String get youveGreatChoiceOfTaste {
    return _localizedValues[locale.languageCode]['youveGreatChoiceOfTaste'];
  }

  String get orderConfirmedWith {
    return _localizedValues[locale.languageCode]['orderConfirmedWith'];
  }

  String get yourOrderWillBeAtYourTable {
    return _localizedValues[locale.languageCode]['yourOrderWillBeAtYourTable'];
  }

  String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  String get knowHowWeCookIt {
    return _localizedValues[locale.languageCode]['knowHowWeCookIt'];
  }

  String get minVideo {
    return _localizedValues[locale.languageCode]['minVideo'];
  }

  String get servings {
    return _localizedValues[locale.languageCode]['servings'];
  }

  String get cookTime {
    return _localizedValues[locale.languageCode]['cookTime'];
  }

  String get people {
    return _localizedValues[locale.languageCode]['people'];
  }

  String get mins {
    return _localizedValues[locale.languageCode]['mins'];
  }

  String get energy {
    return _localizedValues[locale.languageCode]['energy'];
  }

  String get cal {
    return _localizedValues[locale.languageCode]['cal'];
  }

  String get ingredients {
    return _localizedValues[locale.languageCode]['ingredients'];
  }

  String get foodItems {
    return _localizedValues[locale.languageCode]['foodItems'];
  }

  String get addOptions {
    return _localizedValues[locale.languageCode]['addOptions'];
  }

  String get addToCart {
    return _localizedValues[locale.languageCode]['addToCart'];
  }

  String get relatedItemsYouMayLike {
    return _localizedValues[locale.languageCode]['relatedItemsYouMayLike'];
  }

  String get ordered {
    return _localizedValues[locale.languageCode]['ordered'];
  }

  String get items {
    return _localizedValues[locale.languageCode]['items'];
  }

  String get table {
    return _localizedValues[locale.languageCode]['table'];
  }

  String get noOrder {
    return _localizedValues[locale.languageCode]['noOrder'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'fr', 'in', 'pt', 'es', 'sq'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
