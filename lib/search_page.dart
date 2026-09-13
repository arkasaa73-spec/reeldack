import 'package:flutter/material.dart';
import 'show.dart';
import 'show_repository.dart';

// ==================================================
// ЛАБА 5: экран поиска
// ==================================================

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Зависим от интерфейса ShowRepository, а не от конкретного
  // TvMazeShowRepository — так в будущем источник данных можно
  // подменить одной строкой.
  final ShowRepository _repository = OmdbShowRepository();
  final TextEditingController _controller = TextEditingController();

  List<Show> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _repository.search(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Не удалось загрузить данные: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск фильмов')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите название фильма',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _search,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final show = _results[index];
                return ListTile(
                  leading: show.imageUrl != null
                      ? Image.network(
                          show.imageUrl!,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.tv, size: 40),
                  title: Text(show.name),
                  subtitle: Text(
                    show.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: show.rating != null
                      ? Text('⭐ ${show.rating}')
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
