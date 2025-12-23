import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tvs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv/on_the_air_tvs_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs])
void main() {
  late OnTheAirTvsBloc onTheAirTvsBloc;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    onTheAirTvsBloc = OnTheAirTvsBloc(mockGetOnTheAirTvs);
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
    expect(onTheAirTvsBloc.state, OnTheAirTvsEmpty());
  });

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return onTheAirTvsBloc;
    },
    act: (bloc) => bloc.add(OnFetchOnTheAirTvs()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirTvsLoading(),
      OnTheAirTvsHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'Should emit [Loading, Error] when get on the air tvs is unsuccessful',
    build: () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onTheAirTvsBloc;
    },
    act: (bloc) => bloc.add(OnFetchOnTheAirTvs()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirTvsLoading(),
      OnTheAirTvsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );
}
