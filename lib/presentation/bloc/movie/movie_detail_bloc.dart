import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailBloc(
    this._getMovieDetail,
    this._getMovieRecommendations,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieDetailState()) {
    on<OnFetchMovieDetail>(
      (event, emit) async {
        emit(state.copyWith(movieState: RequestState.Loading));

        final detailResult = await _getMovieDetail.execute(event.id);
        final recommendationResult =
            await _getMovieRecommendations.execute(event.id);

        detailResult.fold(
          (failure) {
            emit(state.copyWith(
              movieState: RequestState.Error,
              message: failure.message,
            ));
          },
          (movie) async {
            emit(state.copyWith(
              movie: movie,
              recommendationState: RequestState.Loading,
            ));

            recommendationResult.fold(
              (failure) {
                emit(state.copyWith(
                  recommendationState: RequestState.Error,
                  message: failure.message,
                ));
              },
              (movies) {
                emit(state.copyWith(
                  recommendationState: RequestState.Loaded,
                  recommendations: movies,
                ));
              },
            );

            emit(state.copyWith(movieState: RequestState.Loaded));
          },
        );
      },
    );

    on<OnAddWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (message) {
          emit(state.copyWith(watchlistMessage: message));
        },
      );

      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnRemoveWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (message) {
          emit(state.copyWith(watchlistMessage: message));
        },
      );

      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final result = await _getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
