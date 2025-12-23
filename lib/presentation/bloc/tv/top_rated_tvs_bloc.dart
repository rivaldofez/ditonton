import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs _getTopRatedTvs;

  TopRatedTvsBloc(this._getTopRatedTvs) : super(TopRatedTvsEmpty()) {
    on<OnFetchTopRatedTvs>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await _getTopRatedTvs.execute();

      result.fold((failure) {
        emit(TopRatedTvsError(failure.message));
      }, (data) {
        emit(TopRatedTvsHasData(data));
      });
    });
  }
}
