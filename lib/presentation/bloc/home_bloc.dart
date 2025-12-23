// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
