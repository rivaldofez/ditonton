import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

enum FilmType { Movie, Tv }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<SetFilmType>((event, emit) {
      emit(state.copyWith(currentFilmType: event.filmType));
    });
  }
}
