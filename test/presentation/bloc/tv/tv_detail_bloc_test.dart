import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchlistStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  const testTvId = 1;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();

    bloc = TvDetailBloc(
      mockGetTvDetail,
      mockGetTvRecommendations,
      mockGetTvWatchlistStatus,
      mockSaveTvWatchlist,
      mockRemoveTvWatchlist,
    );
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'success case',
    build: () {
      when(mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));

      when(mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right([testTv]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvDetail(testTvId)),
    expect: () => [
      const TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Loading,
        tv: testTvDetail,
      ),
      TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Loaded,
        tv: testTvDetail,
        recommendations: [testTv],
      ),
      TvDetailState(
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tv: testTvDetail,
        recommendations: [testTv],
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits error when tv detail fails',
    build: () {
      when(mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      when(mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right([testTv]));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvDetail(testTvId)),
    expect: () => [
      const TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      const TvDetailState(
        tvState: RequestState.Error,
        recommendationState: RequestState.Empty,
        message: 'Server Error',
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits recommendation error when recommendation fails',
    build: () {
      when(mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));

      when(mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      return bloc;
    },
    act: (bloc) => bloc.add(OnFetchTvDetail(testTvId)),
    expect: () => [
      const TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
      TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Loading,
        tv: testTvDetail,
      ),
      TvDetailState(
        tvState: RequestState.Loading,
        recommendationState: RequestState.Error,
        tv: testTvDetail,
        message: 'Failed',
      ),
      TvDetailState(
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Error,
        tv: testTvDetail,
        message: 'Failed', // ✅ KEEP MESSAGE
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits success message & watchlist status when add watchlist succeeds',
    build: () {
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));

      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);

      return bloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testTvDetail)),
    expect: () => [
      const TvDetailState(
        watchlistMessage: TvDetailBloc.watchlistAddSuccessMessage,
      ),
      const TvDetailState(
        isAddedToWatchlist: true,
        watchlistMessage: TvDetailBloc.watchlistAddSuccessMessage,
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits success message when remove watchlist succeeds',
    build: () {
      when(mockRemoveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));

      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(OnRemoveWatchlist(testTvDetail)),
    expect: () => [
      const TvDetailState(
        watchlistMessage: TvDetailBloc.watchlistRemoveSuccessMessage,
        isAddedToWatchlist: false, // stays false
      ),
    ],
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits error message when add watchlist fails',
    build: () {
      when(mockSaveTvWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('DB Error')));

      when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      return bloc;
    },
    act: (bloc) => bloc.add(OnAddWatchlist(testTvDetail)),
    expect: () => [
      const TvDetailState(
        watchlistMessage: 'DB Error',
        isAddedToWatchlist: false, // unchanged, but explicit
      ),
    ],
  );
}
