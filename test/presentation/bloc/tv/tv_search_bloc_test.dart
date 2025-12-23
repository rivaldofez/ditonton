import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:ditonton/presentation/bloc/tv/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc searchBloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    searchBloc = TvSearchBloc(mockSearchTvs);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, TvSearchEmpty());
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
  final tQuery = 'avatar';

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      TvSearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      TvSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );
}
