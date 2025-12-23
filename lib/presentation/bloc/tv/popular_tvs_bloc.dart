import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs _getPopularTvs;

  PopularTvsBloc(this._getPopularTvs) : super(PopularTvsEmpty()) {
    on<OnFetchPopularTvs>((event, emit) async {
      emit(PopularTvsLoading());
      final result = await _getPopularTvs.execute();

      result.fold((failure) {
        emit(PopularTvsError(failure.message));
      }, (data) {
        emit(PopularTvsHasData(data));
      });
    });
  }
}
