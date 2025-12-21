import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      adult: false,
      backdropPath: "backdropPath",
      genreIds: [1, 2, 3],
      id: 1,
      originCountry: ["en"],
      originalLanguage: "originalLanguage",
      originalName: "originalName",
      overview: "overview",
      popularity: 1,
      posterPath: "posterPath",
      firstAirDate: "firstAirDate",
      name: "name",
      voteAverage: 1,
      voteCount: 1);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/tv_airing_today.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "backdropPath",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "origin_country": ["en"],
            "original_language": "originalLanguage",
            "original_name": "originalName",
            "overview": "overview",
            "popularity": 1,
            "poster_path": "posterPath",
            "first_air_date": "firstAirDate",
            "name": "name",
            "vote_average": 1,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
