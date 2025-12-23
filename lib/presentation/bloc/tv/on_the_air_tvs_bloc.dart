import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tvs_event.dart';
part 'on_the_air_tvs_state.dart';

class OnTheAirTvsBloc extends Bloc<OnTheAirTvsEvent, OnTheAirTvsState> {
  final GetOnTheAirTvs _getOnTheAirTvs;

  OnTheAirTvsBloc(this._getOnTheAirTvs) : super(OnTheAirTvsEmpty()) {
    on<OnFetchOnTheAirTvs>((event, emit) async {
      emit(OnTheAirTvsLoading());
      final result = await _getOnTheAirTvs.execute();

      result.fold((failure) {
        emit(OnTheAirTvsError(failure.message));
      }, (data) {
        emit(OnTheAirTvsHasData(data));
      });
    });
  }
}
