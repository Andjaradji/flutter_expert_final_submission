import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';
import '../../common/utils.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv.dart';
import '../provider/movie_list_notifier.dart';
import '../provider/tv_list_notifier.dart';
import 'about_page.dart';
import 'movie_detail_page.dart';
import 'popular_movies_page.dart';
import 'popular_tv_series_page.dart';
import 'search_page.dart';
import 'search_tv_series_page.dart';
import 'top_rated_movies_page.dart';
import 'tv_detail_page.dart';
import 'watchlist_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> with RouteAware {
  bool isMovie = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    isMovie
        ? Future.microtask(
            () => Provider.of<MovieListNotifier>(context, listen: false)
              ..fetchNowPlayingMovies()
              ..fetchPopularMovies()
              ..fetchTopRatedMovies())
        : Future.microtask(
            () => Provider.of<TvListNotifier>(context, listen: false)
              ..fetchOnAirTvShows()
              ..fetchPopularTvSeries()
              ..fetchTopRatedTvSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchData();
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
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                setState(() {
                  isMovie = true;
                });

                _fetchData();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_sharp),
              title: Text('Tv Shows'),
              onTap: () {
                setState(() {
                  isMovie = false;
                });
                _fetchData();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                // Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
                Navigator.pushNamed(context, WatchListPage.ROUTE_NAME);
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
              isMovie
                  ? Navigator.pushNamed(context, SearchPage.ROUTE_NAME)
                  : Navigator.pushNamed(context, SearchTvSeriesPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                isMovie ? 'Now Playing' : 'On Air',
                style: kHeading6,
              ),
              isMovie
                  ? Consumer<MovieListNotifier>(
                      builder: (context, data, child) {
                      final state = data.nowPlayingState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(data.nowPlayingMovies);
                      } else {
                        return Text('Failed');
                      }
                    })
                  : Consumer<TvListNotifier>(builder: (context, data, child) {
                      final state = data.onAirState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(data.onAirTvShows);
                      } else {
                        return Text('Failed');
                      }
                    }),
              _buildSubHeading(
                  title: isMovie ? 'Popular' : 'Popular Series',
                  onTap: isMovie
                      ? () => Navigator.pushNamed(
                          context, PopularMoviesPage.ROUTE_NAME)
                      : () =>
                          Navigator.pushNamed(
                              context, ListTvSeriesPage.ROUTE_NAME,
                              arguments: true)),
              isMovie
                  ? Consumer<MovieListNotifier>(
                      builder: (context, data, child) {
                      final state = data.popularMoviesState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(data.popularMovies);
                      } else {
                        return Text('Failed');
                      }
                    })
                  : Consumer<TvListNotifier>(builder: (context, data, child) {
                      final state = data.popularState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(data.popularTvSeries);
                      } else {
                        return Text('Failed');
                      }
                    }),
              _buildSubHeading(
                  title: isMovie ? 'Top Rated' : 'Top Rated Series',
                  onTap: isMovie
                      ? () => Navigator.pushNamed(
                          context, TopRatedMoviesPage.ROUTE_NAME)
                      : ()  => Navigator.pushNamed(
                        context, ListTvSeriesPage.ROUTE_NAME,
                        arguments: false)),
              isMovie
                  ? Consumer<MovieListNotifier>(
                      builder: (context, data, child) {
                      final state = data.topRatedMoviesState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(data.topRatedMovies);
                      } else {
                        return Text('Failed');
                      }
                    })
                  : Consumer<TvListNotifier>(builder: (context, data, child) {
                      final state = data.topRatedTvState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(data.topRatedTvSeries);
                      } else {
                        return Text('Failed');
                      }
                    }),
            ]),
          )),
    );
  }


  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvShows;

  TvList(this.tvShows);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvShows[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShows.length,
      ),
    );
  }
}
