import 'package:flutter_bloc/flutter_bloc.dart';
import 'show.dart';
import 'show_repository.dart';

// ==================================================
// ЛАБА 6: BLoC - события (Events)
// ==================================================
// Событие - говорит о том что "происходит" в UI и о чём мы сообщаем
// в BLoC. Сам виджет не решает, что делать с этим событием
// он просто говорит "пользователь запросил поиск по такому-то
// тексту", а дальше уже дело BLoC.
abstract class SearchEvent {}

class SearchRequested extends SearchEvent {
  final String query;
  SearchRequested(this.query);
}

// ==================================================
// ЛАБА 6: BLoC — состояния (States)
// ==================================================
// Состояние - это "снимок" того, что сейчас должно быть
// нарисовано на экране. UI подписывается на состояния и просто
// перерисовывается, когда состояние меняется - сам он ничего
// не вычисляет.
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Show> results;
  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// ==================================================
// ЛАБА 6: сам BLoC - вся логика поиска здесь,
// а не в виджете экрана
// ==================================================
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ShowRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    // Говорим: "когда придёт событие SearchRequested,
    // обработай его методом _onSearchRequested"
    on<SearchRequested>(_onSearchRequested);
  }

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await _repository.search(query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError('Не удалось загрузить данные: $e'));
    }
  }
}
