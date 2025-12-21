import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_tvs_notifier_test.mocks.dart';
import 'on_the_air_tvs_notifier_test.mocks.dart';
import 'popular_tvs_notifier_test.mocks.dart';
import 'top_rated_tvs_notifier_test.mocks.dart';

@GenerateMocks(
    [GetAiringTodayTvs, GetOnTheAirTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListNotifier provider;
  late MockGetAiringTodayTvs mockGetAiringTodayTvs;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTvs = MockGetAiringTodayTvs();
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    provider = TvListNotifier(
        getAiringTodayTvs: mockGetAiringTodayTvs,
        getOnTheAirTvs: mockGetOnTheAirTvs,
        getPopularTvs: mockGetPopularTvs,
        getTopRatedTvs: mockGetTopRatedTvs)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
      adult: false,
      backdropPath: "/kU98MbVVgi72wzceyrEbClZmMFe.jpg",
      genreIds: [16, 10759, 10765],
      id: 246,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Avatar: The Last Airbender",
      overview:
          "In a war-torn world of elemental magic, a young boy reawakens to undertake a dangerous mystic quest to fulfill his destiny as the Avatar, and bring peace to the world.",
      popularity: 10.993,
      posterPath: "/lzZpWEaqzP0qVA5nkCc5ASbNcSy.jpg",
      firstAirDate: "2024-02-22",
      name: "Avatar the Last Airbender",
      voteAverage: 7.769,
      voteCount: 1010);
  final tTvList = <Tv>[tTv];

  group('airing today tv series', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTvs();
      // assert
      verify(mockGetAiringTodayTvs.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.Loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.Loaded);
      expect(provider.airingTodayTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv series data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Loaded);
      expect(provider.popularTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Loading);
    });

    test('should change tv series data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Loaded);
      expect(provider.topRatedTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('on the air tv series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Loading);
    });

    test('should change tv series data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Loaded);
      expect(provider.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
