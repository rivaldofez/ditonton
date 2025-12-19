import 'package:flutter/cupertino.dart';

enum FilmType { Movie, Tv }

class HomeNotifier extends ChangeNotifier {
  FilmType _currentFilmType = FilmType.Movie;
  FilmType get currentFilmType => _currentFilmType;

  void setCurrentFilmType(FilmType type) {
    _currentFilmType = type;
    notifyListeners();
  }
}
