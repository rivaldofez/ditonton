import 'package:ditonton/presentation/bloc/movie/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home/body_home_movie.dart';
import 'package:ditonton/presentation/pages/home/body_home_tv.dart';
import 'package:ditonton/presentation/pages/movie/search_movie_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tvs_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/home_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MovieListBloc>().add(FetchNowPlayingMovies());
      context.read<MovieListBloc>().add(FetchPopularMovies());
      context.read<MovieListBloc>().add(FetchTopRatedMovies());

      final tvProvider = context.read<TvListNotifier>();

      tvProvider
        ..fetchAiringTodayTvs()
        ..fetchOnTheAirTvs()
        ..fetchPopularTvs()
        ..fetchTopRatedTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                context.read<HomeNotifier>().setCurrentFilmType(FilmType.Movie);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_rounded),
              title: Text('Tv Series'),
              onTap: () {
                context.read<HomeNotifier>().setCurrentFilmType(FilmType.Tv);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.reset_tv_outlined),
              title: Text('TV Series Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvsPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              if (context.read<HomeNotifier>().currentFilmType ==
                  FilmType.Movie) {
                Navigator.pushNamed(context, SearchMoviePage.ROUTE_NAME);
              } else {
                Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
              }
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<HomeNotifier>(
            builder: (context, home, _) {
              switch (home.currentFilmType) {
                case FilmType.Tv:
                  return const BodyHomeTv();

                case FilmType.Movie:
                  return const BodyHomeMovie();
              }
            },
          )),
    );
  }
}
