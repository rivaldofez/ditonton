import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv/watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTvs);
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
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnFetchWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvs.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when get watchlist tvs is unsuccessful',
    build: () {
      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(OnFetchWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvs.execute());
    },
  );
}
