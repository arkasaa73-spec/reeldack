import 'show_dto.dart';

// ==================================================
// ЛАБА 5: доменная модель — то, чем пользуется UI
// ==================================================
//
// В отличие от DTO, тут уже нет "мусора" из API — например,
// вместо отдельного поля "Year" сразу формируем готовую для
// показа строку описания.

class Show {
  final String id;
  final String name;
  final String summary;
  final String? imageUrl;
  final double? rating;

  Show({
    required this.id,
    required this.name,
    required this.summary,
    this.imageUrl,
    this.rating,
  });

  // Превращаем "сырой" DTO в чистую модель
  factory Show.fromDto(ShowDto dto) {
    final hasPoster = dto.posterUrl != null && dto.posterUrl != 'N/A';

    return Show(
      id: dto.imdbId,
      name: dto.title,
      summary: 'Год выпуска: ${dto.year}',
      imageUrl: hasPoster ? dto.posterUrl : null,
      rating: null, // OMDb отдаёт рейтинг только в отдельном запросе по id
    );
  }
}
