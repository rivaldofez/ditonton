import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;

    setUp(() {
      homeBloc = HomeBloc();
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state should be Movie', () {
      expect(
        homeBloc.state,
        const HomeState(currentFilmType: FilmType.Movie),
      );
    });

    blocTest<HomeBloc, HomeState>(
      'emits [Tv] when SetFilmType(Tv) is added',
      build: () => HomeBloc(),
      act: (bloc) => bloc.add(const SetFilmType(FilmType.Tv)),
      expect: () => [
        const HomeState(currentFilmType: FilmType.Tv),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [Movie] when SetFilmType(Movie) is added',
      build: () => HomeBloc(),
      act: (bloc) => bloc.add(const SetFilmType(FilmType.Movie)),
      expect: () => [
        const HomeState(currentFilmType: FilmType.Movie),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits multiple states when film type changes multiple times',
      build: () => HomeBloc(),
      act: (bloc) {
        bloc.add(const SetFilmType(FilmType.Tv));
        bloc.add(const SetFilmType(FilmType.Movie));
      },
      expect: () => [
        const HomeState(currentFilmType: FilmType.Tv),
        const HomeState(currentFilmType: FilmType.Movie),
      ],
    );
  });
}
