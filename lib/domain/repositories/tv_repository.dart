import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getAiringTodayTvs();
  Future<Either<Failure, List<Tv>>> getPopularTvs();
  Future<Either<Failure, List<Tv>>> getTopRatedTvs();
  Future<Either<Failure, List<Tv>>> getOnTheAirTvs();
  // Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  // Future<Either<Failure, List<Tv>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTvs(String query);
  // Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  // Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  // Future<bool> isAddedToWatchlist(int id);
  // Future<Either<Failure, List<Tv>>> getWatchlistMovies();
}
