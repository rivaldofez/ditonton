part of 'on_the_air_tvs_bloc.dart';

abstract class OnTheAirTvsState extends Equatable {
  const OnTheAirTvsState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvsEmpty extends OnTheAirTvsState {}

class OnTheAirTvsLoading extends OnTheAirTvsState {}

class OnTheAirTvsError extends OnTheAirTvsState {
  final String message;

  OnTheAirTvsError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirTvsHasData extends OnTheAirTvsState {
  final List<Tv> result;

  OnTheAirTvsHasData(this.result);

  @override
  List<Object> get props => [result];
}
