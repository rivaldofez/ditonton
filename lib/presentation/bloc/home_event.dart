part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class SetFilmType extends HomeEvent {
  final FilmType filmType;

  const SetFilmType(this.filmType);

  @override
  List<Object?> get props => [filmType];
}
