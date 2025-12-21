import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
      adult: false,
      backdropPath: "backdropPath",
      genreIds: [],
      id: 1,
      originCountry: [],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      firstAirDate: "firstAirDate",
      name: "name",
      voteAverage: 1,
      voteCount: 1);

  final tTv = Tv(
      adult: false,
      backdropPath: "backdropPath",
      genreIds: [],
      id: 1,
      originCountry: [],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      firstAirDate: "firstAirDate",
      name: "name",
      voteAverage: 1,
      voteCount: 1);

  test('should be a subclass of Movie entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
