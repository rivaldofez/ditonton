part of 'airing_today_tvs_bloc.dart';

abstract class AiringTodayTvsState extends Equatable {
  const AiringTodayTvsState();

  @override
  List<Object> get props => [];
}

class AiringTodayTvsEmpty extends AiringTodayTvsState {}

class AiringTodayTvsLoading extends AiringTodayTvsState {}

class AiringTodayTvsError extends AiringTodayTvsState {
  final String message;

  AiringTodayTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class AiringTodayTvsHasData extends AiringTodayTvsState {
  final List<Tv> result;

  AiringTodayTvsHasData(this.result);

  @override
  List<Object> get props => [result];
}
