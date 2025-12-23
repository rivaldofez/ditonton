import 'package:ditonton/presentation/bloc/tv/airing_today_tvs_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/airing-today-tvs';

  @override
  _AiringTodayTvsPageState createState() => _AiringTodayTvsPageState();
}

class _AiringTodayTvsPageState extends State<AiringTodayTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<AiringTodayTvsBloc>().add(OnFetchAiringTodayTvs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airing Today Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTvsBloc, AiringTodayTvsState>(
          builder: (context, state) {
            if (state is AiringTodayTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AiringTodayTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return TvCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is AiringTodayTvsError) {
              return Expanded(
                child: Center(
                  child: Text(state.message),
                ),
              );
            } else {
              return Expanded(
                child: Container(),
              );
            }
          },
        ),
      ),
    );
  }
}
