import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'airing_today_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTvs])
void main() {
  late AiringTodayTvsBloc airingTodayTvsBloc;
  late MockGetAiringTodayTvs mockGetAiringTodayTvs;

  setUp(() {
    mockGetAiringTodayTvs = MockGetAiringTodayTvs();
    airingTodayTvsBloc = AiringTodayTvsBloc(mockGetAiringTodayTvs);
  });

  final tTvModel = Tv(
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
  final tTvList = <Tv>[tTvModel];

  test('initial state should be empty', () {
    expect(airingTodayTvsBloc.state, AiringTodayTvsEmpty());
  });

  blocTest<AiringTodayTvsBloc, AiringTodayTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return airingTodayTvsBloc;
    },
    act: (bloc) => bloc.add(OnFetchAiringTodayTvs()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      AiringTodayTvsLoading(),
      AiringTodayTvsHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvs.execute());
    },
  );

  blocTest<AiringTodayTvsBloc, AiringTodayTvsState>(
    'Should emit [Loading, Error] when get airing today tvs is unsuccessful',
    build: () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return airingTodayTvsBloc;
    },
    act: (bloc) => bloc.add(OnFetchAiringTodayTvs()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      AiringTodayTvsLoading(),
      AiringTodayTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTvs.execute());
    },
  );
}
