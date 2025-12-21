import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testTv = Tv(
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

final testMovieList = [testMovie];

final testTvList = [testTv];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testTvDetail = TvDetail(
    adult: false,
    backdropPath: "/imlTCObfzISogbvcwB1dokoXAIc.jpg",
    episodeRunTime: [],
    firstAirDate: "2024-02-22",
    homepage: "https://www.netflix.com/title/80237957",
    id: 82452,
    inProduction: true,
    languages: ["en"],
    lastAirDate: "2024-02-22",
    name: "Avatar the Last Airbender",
    numberOfEpisodes: 8,
    numberOfSeasons: 2,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Avatar the Last Airbender",
    overview:
        "A young boy known as the Avatar must master the four elemental powers to save a world at war — and fight a ruthless enemy bent on stopping him.",
    popularity: 21.9457,
    posterPath: "/lzZpWEaqzP0qVA5nkCc5ASbNcSy.jpg",
    status: "Returning Series",
    tagline: "The epic saga continues.",
    type: "Scripted",
    voteAverage: 7.769,
    voteCount: 1010);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchListTv = Tv.watchlist(
    id: 82452,
    name: "Avatar the Last Airbender",
    posterPath: "/lzZpWEaqzP0qVA5nkCc5ASbNcSy.jpg",
    overview:
        "A young boy known as the Avatar must master the four elemental powers to save a world at war — and fight a ruthless enemy bent on stopping him.");

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
    id: 82452,
    name: "Avatar the Last Airbender",
    posterPath: "/lzZpWEaqzP0qVA5nkCc5ASbNcSy.jpg",
    overview:
        "A young boy known as the Avatar must master the four elemental powers to save a world at war — and fight a ruthless enemy bent on stopping him.");

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvMap = {
  'id': 82452,
  'overview':
      'A young boy known as the Avatar must master the four elemental powers to save a world at war — and fight a ruthless enemy bent on stopping him.',
  'posterPath': '/lzZpWEaqzP0qVA5nkCc5ASbNcSy.jpg',
  'name': 'Avatar the Last Airbender'
};
