import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_bloc.dart';
import 'show_repository.dart';

// ==================================================
// ЛАБА 6: экран теперь "глупый" - вся логика в SearchBloc,
// сам виджет только отправляет события и рисует состояния
// ==================================================

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider создаёт BLoC и делает его доступным
    // для всех виджетов ниже по дереву через context.read/watch
    return BlocProvider(
      create: (_) => SearchBloc(OmdbShowRepository()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  String _lastQuery = '';

  // ЛАБА 6: Debounce - не ищем на каждую введённую букву,
  // а ждём паузу в 500 мс. Если за это время пользователь
  // напечатал ещё что-то - старый таймер отменяется, и отсчёт
  // начинается заново. Запрос улетает только когда человек
  // ненадолго остановился печатать.
  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _lastQuery = query;
      context.read<SearchBloc>().add(SearchRequested(query));
    });
  }

  // ЛАБА 6: обновление страницы по жесту "потянуть вниз"
  Future<void> _onRefresh() async {
    if (_lastQuery.isNotEmpty) {
      context.read<SearchBloc>().add(SearchRequested(_lastQuery));
    }
    // небольшая пауза, чтобы анимация обновления не мигала мгновенно
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
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
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Введите название фильма',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onQueryChanged,
            ),
          ),
          Expanded(
            // BlocBuilder перерисовывает всё, что внутри, каждый раз,
            // когда SearchBloc публикует новое состояние
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const Center(
                    child: Text('Начните вводить название фильма'),
                  );
                }
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SearchError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final results = (state as SearchLoaded).results;
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final show = results[index];
                      return ListTile(
                        leading: show.imageUrl != null
                            ? Image.network(
                                show.imageUrl!,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.movie, size: 40),
                        title: Text(show.name),
                        subtitle: Text(show.summary),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
