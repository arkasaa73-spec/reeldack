import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'search_page.dart';

void main() {
  runApp(const MyApp());
}

// ==================================================
// ЛАБА 3: Модель данных и список карточек
// ==================================================

// Модель данных фильма
class Movie {
  final String title;
  final String shortDescription; // краткое описание — для списка
  final String description; // подробное описание — для экрана деталей
  final String imagePath;
  final int year;
  final String genre;
  final double rating;
  bool isLiked;

  Movie({
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.imagePath,
    required this.year,
    required this.genre,
    required this.rating,
    this.isLiked = false,
  });
}

// Список фильмов (пока просто захардкожен прямо в коде)
final List<Movie> movies = [
  Movie(
    title: 'Тень за спиной',
    shortDescription: 'Детектив против призраков прошлого.',
    description:
        'Детектив расследует серию загадочных исчезновений в маленьком городке. '
        'С каждым новым делом он находит всё больше связей со старым, давно '
        'забытым преступлением, которое город предпочёл замолчать. Чем глубже '
        'он копает, тем яснее становится: кто-то из местных жителей знает '
        'намного больше, чем говорит. Время поджимает — исчезновения '
        'продолжаются, а список подозреваемых растёт с каждым днём.',
    imagePath: 'assets/images/movie1.jpg',
    year: 2023,
    genre: 'Детектив',
    rating: 7.4,
  ),
  Movie(
    title: 'Последний рейс',
    shortDescription: 'Контрабанда ради спасения брата.',
    description:
        'Водитель грузовика Салли вынуждена заниматься контрабандой запрещённых '
        'грузов, чтобы спасти своего брата от смертельно опасной тюремной '
        'банды. Каждый рейс — это риск попасться полиции или самим бандитам, '
        'а сроки поджимают. По пути ей приходится принимать решения, которые '
        'ставят под угрозу не только её жизнь, но и жизни случайных людей, '
        'встретившихся на пути.',
    imagePath: 'assets/images/movie2.jpg',
    year: 2022,
    genre: 'Боевик',
    rating: 6.8,
  ),
  Movie(
    title: 'Огни большого города',
    shortDescription: 'Дружба и предательство в мегаполисе.',
    description:
        'История дружбы и предательства на фоне ночной жизни мегаполиса. '
        'Трое друзей детства идут каждый своим путём — один выбирает бизнес, '
        'другой криминал, третий пытается остаться просто честным человеком. '
        'Их пути неизбежно пересекаются вновь, и старая дружба проверяется на '
        'прочность деньгами, властью и старыми обидами.',
    imagePath: 'assets/images/movie3.jpg',
    year: 2021,
    genre: 'Драма',
    rating: 7.9,
  ),
  Movie(
    title: 'Соленая тропа',
    shortDescription: 'Выживание в горах любой ценой.',
    description:
        'Группа туристов теряется в горах и должна выжить любой ценой. Когда '
        'непогода отрезает единственную дорогу назад, а связь с миром '
        'пропадает, вчерашние незнакомцы вынуждены довериться друг другу. '
        'Нехватка еды и постоянная угроза срывов со скал заставляют каждого '
        'показать, на что он способен на самом деле.',
    imagePath: 'assets/images/movie4.jpg',
    year: 2020,
    genre: 'Триллер',
    rating: 6.5,
  ),
  Movie(
    title: 'Второй шанс',
    shortDescription: 'Не поздно всё исправить.',
    description:
        'Драма о человеке, который получает возможность исправить ошибки '
        'прошлого. После несчастного случая герой заново переосмысливает всю '
        'свою жизнь и решает вернуть то, что когда-то потерял из-за собственной '
        'гордости. Но оказывается, что изменить себя куда проще, чем убедить '
        'в этих переменах тех, кого он когда-то предал.',
    imagePath: 'assets/images/movie5.jpg',
    year: 2024,
    genre: 'Драма',
    rating: 8.1,
  ),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ЛАБА 7: язык храним прямо тут, а не берём из настроек телефона
  Locale _locale = const Locale('ru');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'ru'
          ? const Locale('en')
          : const Locale('ru');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лаба 3-7 — Фильмы',
      // ЛАБА 7: подключаем локализацию
      locale: _locale, // явно задаём язык вместо того, чтобы брать из системы
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MovieListPage(onToggleLanguage: _toggleLanguage),
    );
  }
}

// ==================================================
// ЛАБА 4: лайки, Snackbar, переход на экран деталей
// ==================================================

// Экран со списком карточек фильмов.
// Раньше был StatelessWidget, теперь StatefulWidget — потому что
// при нажатии на лайк нужно менять данные и перерисовывать экран.
class MovieListPage extends StatefulWidget {
  final VoidCallback onToggleLanguage;

  const MovieListPage({super.key, required this.onToggleLanguage});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}


class _MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
    _loadLikes(); // ЛАБА 7: подгружаем сохранённые лайки при запуске
  }

  // ЛАБА 7: SharedPreferences — простое хранилище "ключ-значение"
  // прямо на устройстве. Данные остаются даже после закрытия
  // приложения (в отличие от обычных переменных в памяти).
  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final movie in movies) {
        movie.isLiked = prefs.getBool('liked_${movie.title}') ?? false;
      }
    });
  }

  Future<void> _saveLike(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('liked_${movie.title}', movie.isLiked);
  }

  // Переключить лайк у конкретного фильма
  void _toggleLike(Movie movie) {
    setState(() {
      // setState говорит Flutter: "данные изменились, перерисуй экран"
      movie.isLiked = !movie.isLiked;
    });
    _saveLike(movie); // сохраняем новое значение на диск

    // Показываем всплывающее уведомление внизу экрана
    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          movie.isLiked
              ? '${loc.likedMovie} "${movie.title}"'
              : '${loc.unlikedMovie} "${movie.title}"',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Открыть экран с подробностями о фильме
  void _openDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).movieListTitle),
        actions: [
          // ЛАБА 7: кнопка переключения языка
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: widget.onToggleLanguage,
          ),
          // ЛАБА 5: переход на экран поиска сериалов через API
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              // InkWell делает всю карточку кликабельной, с эффектом "ряби" при нажатии
              onTap: () => _openDetails(movie),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    movie.imagePath,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Кнопка лайка — отдельная от общего onTap карточки,
                            // поэтому нажатие на неё не открывает детали
                            IconButton(
                              icon: Icon(
                                movie.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: movie.isLiked ? Colors.red : null,
                              ),
                              onPressed: () => _toggleLike(movie),
                            ),
                          ],
                        ),
                        Text(movie.shortDescription),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Экран с подробной информацией о фильме
class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              movie.imagePath,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _DetailChip(icon: Icons.calendar_today, label: '${movie.year}'),
                      _DetailChip(icon: Icons.theater_comedy, label: movie.genre),
                      _DetailChip(icon: Icons.star, label: '${movie.rating}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        movie.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: movie.isLiked ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(movie.isLiked ? 'Вам нравится' : 'Пока не нравится'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Маленькая плашка "иконка + текст" для доп. полей на экране деталей
class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}
