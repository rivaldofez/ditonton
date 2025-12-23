import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/common/failure.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  const testMovieId = 1;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    bloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'success case',
    build: () {
      when(mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right([testMovie]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMovieDetail(testMovieId)),
    expect: () => [
      const MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Loading,
        movie: testMovieDetail,
      ),
      MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Loaded,
        movie: testMovieDetail,
        recommendations: [testMovie],
      ),
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movie: testMovieDetail,
        recommendations: [testMovie],
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits error when movie detail fails',
    build: () {
      when(mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      when(mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right([testMovie]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMovieDetail(testMovieId)),
    expect: () => [
      const MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      const MovieDetailState(
        movieState: RequestState.Error,
        recommendationState: RequestState.Empty,
        message: 'Server Error',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits recommendation error when recommendation fails',
    build: () {
      when(mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieDetail));

      when(mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchMovieDetail(testMovieId)),
    expect: () => [
      const MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Loading,
        movie: testMovieDetail,
      ),
      MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Error,
        movie: testMovieDetail,
        message: 'Failed',
      ),
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Error,
        movie: testMovieDetail,
        message: 'Failed', // ✅ KEEP MESSAGE
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits success message & watchlist status when add watchlist succeeds',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));

      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testMovieDetail)),
    expect: () => [
      const MovieDetailState(
        watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
      ),
      const MovieDetailState(
        isAddedToWatchlist: true,
        watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits success message when remove watchlist succeeds',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));

      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchlist(testMovieDetail)),
    expect: () => [
      const MovieDetailState(
        watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
        isAddedToWatchlist: false, // stays false
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits error message when add watchlist fails',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('DB Error')));

      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testMovieDetail)),
    expect: () => [
      const MovieDetailState(
        watchlistMessage: 'DB Error',
        isAddedToWatchlist: false, // unchanged, but explicit
      ),
    ],
  );
}
