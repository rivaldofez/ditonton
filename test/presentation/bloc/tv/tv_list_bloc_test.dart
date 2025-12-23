import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/tv/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'airing_today_tvs_bloc_test.mocks.dart';
import 'on_the_air_tvs_bloc_test.mocks.dart';
import 'popular_tvs_bloc_test.mocks.dart';
import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTvs,
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
])
void main() {
  late TvListBloc bloc;
  late MockGetAiringTodayTvs mockGetAiringTodayTvs;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetAiringTodayTvs = MockGetAiringTodayTvs();
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();

    bloc = TvListBloc(
      getAiringTodayTvs: mockGetAiringTodayTvs,
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final testTvList = <Tv>[testTv];

  blocTest<TvListBloc, TvListState>(
    'emits Loading → Loaded when airing today TVs succeed',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTvs()),
    expect: () => [
      const TvListState(airingTodayState: RequestState.Loading),
      TvListState(
        airingTodayState: RequestState.Loaded,
        airingTodayTvs: testTvList,
      ),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'emits Error when airing today TVs fail',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTvs()),
    expect: () => [
      const TvListState(airingTodayState: RequestState.Loading),
      const TvListState(
        airingTodayState: RequestState.Error,
        message: 'Server Error',
      ),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'emits Loading → Loaded when on the air TVs succeed',
    build: () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvs()),
    expect: () => [
      const TvListState(onTheAirState: RequestState.Loading),
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: testTvList,
      ),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'emits Loading → Loaded when popular TVs succeed',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvs()),
    expect: () => [
      const TvListState(popularTvsState: RequestState.Loading),
      TvListState(
        popularTvsState: RequestState.Loaded,
        popularTvs: testTvList,
      ),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'emits Loading → Loaded when top rated TVs succeed',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      const TvListState(topRatedTvsState: RequestState.Loading),
      TvListState(
        topRatedTvsState: RequestState.Loaded,
        topRatedTvs: testTvList,
      ),
    ],
  );
}
