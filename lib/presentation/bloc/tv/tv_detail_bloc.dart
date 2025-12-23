import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/common/state_enum.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail _getTvDetail;
  final GetTvRecommendations _getTvRecommendations;
  final GetTvWatchlistStatus _getWatchListStatus;
  final SaveTvWatchlist _saveWatchlist;
  final RemoveTvWatchlist _removeWatchlist;

  TvDetailBloc(
    this._getTvDetail,
    this._getTvRecommendations,
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(TvDetailState()) {
    on<OnFetchTvDetail>(
      (event, emit) async {
        emit(state.copyWith(tvState: RequestState.Loading));

        final detailResult = await _getTvDetail.execute(event.id);
        final recommendationResult =
            await _getTvRecommendations.execute(event.id);

        detailResult.fold(
          (failure) {
            emit(state.copyWith(
              tvState: RequestState.Error,
              message: failure.message,
            ));
          },
          (tv) async {
            emit(state.copyWith(
              tv: tv,
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

            emit(state.copyWith(tvState: RequestState.Loaded));
          },
        );
      },
    );

    on<OnAddWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.tv);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (message) {
          emit(state.copyWith(watchlistMessage: message));
        },
      );

      add(OnLoadWatchlistStatus(event.tv.id));
    });

    on<OnRemoveWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.tv);
      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (message) {
          emit(state.copyWith(watchlistMessage: message));
        },
      );

      add(OnLoadWatchlistStatus(event.tv.id));
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final result = await _getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
