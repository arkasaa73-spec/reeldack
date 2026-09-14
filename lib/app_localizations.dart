import 'package:flutter/material.dart';

// ==================================================
// ЛАБА 7: Локализация - простой вариант без кодогенерации
// ==================================================
//
// AppLocalizations хранит переводы всех текстов приложения
// в виде обычных Map<строка-ключ, строка-перевод>, отдельно
// для каждого языка. Экраны обращаются не к самому тексту,
// а к AppLocalizations.of(context).что-то и получают перевод
// на текущий язык устройства.

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  // Удобный способ получить объект локализации из любого места,
  // где есть context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'ru': {
      'movieListTitle': 'Список фильмов',
      'searchTitle': 'Поиск фильмов',
      'searchHint': 'Введите название фильма',
      'likedMovie': 'Вам понравился фильм',
      'unlikedMovie': 'Лайк убран с фильма',
      'initialSearchHint': 'Начните вводить название фильма',
    },
    'en': {
      'movieListTitle': 'Movie List',
      'searchTitle': 'Search Movies',
      'searchHint': 'Enter movie title',
      'likedMovie': 'You liked the movie',
      'unlikedMovie': 'Like removed from movie',
      'initialSearchHint': 'Start typing a movie title',
    },
  };

  String _t(String key) =>
      _localizedValues[locale.languageCode]?[key] ?? key;

  String get movieListTitle => _t('movieListTitle');
  String get searchTitle => _t('searchTitle');
  String get searchHint => _t('searchHint');
  String get likedMovie => _t('likedMovie');
  String get unlikedMovie => _t('unlikedMovie');
  String get initialSearchHint => _t('initialSearchHint');
}

// Delegate - "поставщик" локализации для MaterialApp.
// Он говорит Flutter: "какие языки я поддерживаю" и "как
// создать объект AppLocalizations для нужного языка".
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
