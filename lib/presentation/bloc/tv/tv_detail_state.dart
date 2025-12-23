part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final RequestState tvState;
  final RequestState recommendationState;
  final TvDetail? tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const TvDetailState({
    this.tvState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.tv,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    RequestState? tvState,
    RequestState? recommendationState,
    TvDetail? tv,
    List<Tv>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tvState: tvState ?? this.tvState,
      recommendationState: recommendationState ?? this.recommendationState,
      tv: tv ?? this.tv,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvState,
        recommendationState,
        tv,
        recommendations,
        isAddedToWatchlist,
        message,
        watchlistMessage,
      ];
}
