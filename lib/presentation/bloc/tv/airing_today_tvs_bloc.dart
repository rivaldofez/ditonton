import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:equatable/equatable.dart';

part 'airing_today_tvs_event.dart';
part 'airing_today_tvs_state.dart';

class AiringTodayTvsBloc
    extends Bloc<AiringTodayTvsEvent, AiringTodayTvsState> {
  final GetAiringTodayTvs _getAiringTodayTvs;

  AiringTodayTvsBloc(this._getAiringTodayTvs) : super(AiringTodayTvsEmpty()) {
    on<OnFetchAiringTodayTvs>((event, emit) async {
      emit(AiringTodayTvsLoading());
      final result = await _getAiringTodayTvs.execute();

      result.fold((failure) {
        emit(AiringTodayTvsError(failure.message));
      }, (data) {
        emit(AiringTodayTvsHasData(data));
      });
    });
  }
}
