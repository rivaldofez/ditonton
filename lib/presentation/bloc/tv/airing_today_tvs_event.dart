part of 'airing_today_tvs_bloc.dart';

abstract class AiringTodayTvsEvent extends Equatable {
  const AiringTodayTvsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchAiringTodayTvs extends AiringTodayTvsEvent {}
