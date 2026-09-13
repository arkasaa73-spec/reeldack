import 'dart:convert';
import 'package:http/http.dart' as http;
import 'show.dart';
import 'show_dto.dart';

// ==================================================
// ЛАБА 5: интерфейс репозитория
// ==================================================
//
// Это просто контракт: "что репозиторий обязан уметь делать",
// без единой детали о том, КАК именно (сеть? база данных?
// файл?). UI-код зависит только от этого интерфейса,
// а не от конкретной реализации — благодаря этому мы только что
// поменяли источник данных (TVMaze -> OMDb), не тронув ни
// show.dart, ни search_page.dart.
abstract class ShowRepository {
  Future<List<Show>> search(String query);
}

// ==================================================
// ЛАБА 5: конкретная реализация — поход в OMDb API
// ==================================================
class OmdbShowRepository implements ShowRepository {
  final http.Client _client;

  // Бесплатный ключ с omdbapi.com
  static const _apiKey = 'da34ce89';

  OmdbShowRepository({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<Show>> search(String query) async {
    final uri = Uri.parse(
      'https://www.omdbapi.com/?s=${Uri.encodeQueryComponent(query)}&apikey=$_apiKey',
    );

    final response = await _client.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception(
          'Сервер не отвечает (тайм-аут). Возможно, сайт недоступен в вашем регионе.',
        );
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

    // OMDb при неудаче отвечает {"Response":"False","Error":"..."}
    if (data['Response'] == 'False') {
      throw Exception(data['Error'] ?? 'Ничего не найдено');
    }

    final List<dynamic> results = data['Search'] as List<dynamic>;

    // JSON -> DTO -> чистая модель Show
    return results
        .map((item) => ShowDto.fromJson(item as Map<String, dynamic>))
        .map((dto) => Show.fromDto(dto))
        .toList();
  }
}
