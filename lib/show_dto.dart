// ==================================================
// ЛАБА 5: DTO — "сырая" модель, повторяющая структуру ответа API
// ==================================================
//
// DTO (Data Transfer Object) нужен, чтобы отделить формат данных
// сервера от формата, которым пользуется наше приложение.
// Если завтра API поменяет структуру ответа — менять придётся
// только этот файл, а не весь проект.
//
// Формат ответа OMDb (поиск): каждый фильм в списке "Search"
// выглядит так:
// { "Title": "...", "Year": "...", "imdbID": "tt...", "Poster": "..." }

class ShowDto {
  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;

  ShowDto({
    required this.imdbId,
    required this.title,
    required this.year,
    this.posterUrl,
  });

  factory ShowDto.fromJson(Map<String, dynamic> json) {
    return ShowDto(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String? ?? 'Без названия',
      year: json['Year'] as String? ?? '?',
      posterUrl: json['Poster'] as String?,
    );
  }
}
