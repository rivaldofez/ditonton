import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;

  TvSearchBloc(this._searchTvs) : super(TvSearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = await event.query;

      emit(TvSearchLoading());
      final result = await _searchTvs.execute(query);

      result.fold((failure) {
        emit(TvSearchError(failure.message));
      }, (data) {
        emit(TvSearchHasData(data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
