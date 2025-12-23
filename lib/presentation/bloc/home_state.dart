part of 'home_bloc.dart';

class HomeState extends Equatable {
  final FilmType currentFilmType;

  const HomeState({
    this.currentFilmType = FilmType.Movie,
  });

  HomeState copyWith({
    FilmType? currentFilmType,
  }) {
    return HomeState(
      currentFilmType: currentFilmType ?? this.currentFilmType,
    );
  }

  @override
  List<Object?> get props => [currentFilmType];
}
