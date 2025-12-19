import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_airing_today_tvs.dart';
import 'package:flutter/foundation.dart';

class AiringTodayTvsNotifier extends ChangeNotifier {
  final GetAiringTodayTvs getAiringTodayTvs;

  AiringTodayTvsNotifier({required this.getAiringTodayTvs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvs = [];
  List<Tv> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvs() async {
    _state = RequestState.Loading;
    notifyListeners();
    print("Logdebug: called");
    final result = await getAiringTodayTvs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        print("Logdebug: got error");
        notifyListeners();
      },
      (tvsData) {
        _tvs = tvsData;
        _state = RequestState.Loaded;
        print("Logdebug: got empty");
        notifyListeners();
      },
    );
  }
}
