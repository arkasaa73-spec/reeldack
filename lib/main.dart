import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ==================================================
// ЛАБА 3: Модель данных и список карточек
// ==================================================

// Модель данных фильма
class Movie {
  final String title;
  final String description;
  final String imagePath;

  Movie({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// Список фильмов (пока просто захардкожен прямо в коде)
final List<Movie> movies = [
  Movie(
    title: 'Тень за спиной',
    description:
        'Детектив расследует серию загадочных исчезновений в маленьком городке.',
    imagePath: 'assets/images/movie1.jpg',
  ),
  Movie(
    title: 'Последний рейс',
    description:
        'Водитель грузовика Салли вынуждена заниматься контрабандой запрещенных грузов, чтобы спасти своего брата от смертельно опасной тюремной банды.',
    imagePath: 'assets/images/movie2.jpg',
  ),
  Movie(
    title: 'Огни большого города',
    description:
        'История дружбы и предательства на фоне ночной жизни мегаполиса.',
    imagePath: 'assets/images/movie3.jpg',
  ),
  Movie(
    title: 'Соленая тропа',
    description: 'Группа туристов теряется в горах и должна выжить любой ценой.',
    imagePath: 'assets/images/movie4.jpg',
  ),
  Movie(
    title: 'Второй шанс',
    description:
        'Драма о человеке, который получает возможность исправить ошибки прошлого.',
    imagePath: 'assets/images/movie5.jpg',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Лаба 3-7 — Фильмы',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieListPage(),
    );
  }
}

// Экран со списком карточек фильмов
class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список фильмов'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
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
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(movie.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
