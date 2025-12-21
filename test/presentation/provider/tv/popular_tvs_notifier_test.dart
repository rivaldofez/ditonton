import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'popular_tvs_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTvs = MockGetPopularTvs();
    notifier = PopularTvsNotifier(getPopularTvs: mockGetPopularTvs)
      ..addListener(() {
        listenerCallCount++;
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
