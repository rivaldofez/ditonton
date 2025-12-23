import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie/movie_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();

    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be MovieListState()', () {
    expect(bloc.state, const MovieListState());
  });

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Loaded] when now playing movies succeed',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      const MovieListState(
        nowPlayingState: RequestState.Loading,
      ),
      MovieListState(
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: testMovieList,
      ),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Error] when now playing movies fail',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      const MovieListState(
        nowPlayingState: RequestState.Loading,
      ),
      const MovieListState(
        nowPlayingState: RequestState.Error,
        message: 'Server Error',
      ),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Loaded] when popular movies succeed',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      const MovieListState(
        popularMoviesState: RequestState.Loading,
      ),
      MovieListState(
        popularMoviesState: RequestState.Loaded,
        popularMovies: testMovieList,
      ),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Error] when popular movies fail',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      const MovieListState(
        popularMoviesState: RequestState.Loading,
      ),
      const MovieListState(
        popularMoviesState: RequestState.Error,
        message: 'Server Error',
      ),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Loaded] when top rated movies succeed',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      const MovieListState(
        topRatedMoviesState: RequestState.Loading,
      ),
      MovieListState(
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: testMovieList,
      ),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [Loading, Error] when top rated movies fail',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      const MovieListState(
        topRatedMoviesState: RequestState.Loading,
      ),
      const MovieListState(
        topRatedMoviesState: RequestState.Error,
        message: 'Server Error',
      ),
    ],
  );
}
