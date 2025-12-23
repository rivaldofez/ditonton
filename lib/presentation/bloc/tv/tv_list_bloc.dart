import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetAiringTodayTvs getAiringTodayTvs;
  final GetOnTheAirTvs getOnTheAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListBloc({
    required this.getAiringTodayTvs,
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TvListState()) {
    on<FetchAiringTodayTvs>(_onFetchAiringTodayTvs);
    on<FetchOnTheAirTvs>(_onFetchOnTheAirTvs);
    on<FetchPopularTvs>(_onFetchPopularTvs);
    on<FetchTopRatedTvs>(_onFetchTopRatedTvs);
  }

  Future<void> _onFetchAiringTodayTvs(
    FetchAiringTodayTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(airingTodayState: RequestState.Loading));

    final result = await getAiringTodayTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          airingTodayState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvs) => emit(
        state.copyWith(
          airingTodayState: RequestState.Loaded,
          airingTodayTvs: tvs,
        ),
      ),
    );
  }

  Future<void> _onFetchOnTheAirTvs(
    FetchOnTheAirTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvs) => emit(
        state.copyWith(
          onTheAirState: RequestState.Loaded,
          onTheAirTvs: tvs,
        ),
      ),
    );
  }

  Future<void> _onFetchPopularTvs(
    FetchPopularTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(popularTvsState: RequestState.Loading));

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularTvsState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvs) => emit(
        state.copyWith(
          popularTvsState: RequestState.Loaded,
          popularTvs: tvs,
        ),
      ),
    );
  }

  Future<void> _onFetchTopRatedTvs(
    FetchTopRatedTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(topRatedTvsState: RequestState.Loading));

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedTvsState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvs) => emit(
        state.copyWith(
          topRatedTvsState: RequestState.Loaded,
          topRatedTvs: tvs,
        ),
      ),
    );
  }
}
