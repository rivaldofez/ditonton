part of 'on_the_air_tvs_bloc.dart';

abstract class OnTheAirTvsEvent extends Equatable {
  const OnTheAirTvsEvent();

  @override
  List<Object> get props => [];
}

class OnFetchOnTheAirTvs extends OnTheAirTvsEvent {}
