import 'package:flutter/foundation.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_watchlist_movies.dart';
import '../../domain/usecases/get_watchlist_tv_series.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvSeries = <Tv>[];
  List<Tv> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistMovieState = RequestState.Empty;
  RequestState get watchlistMovieState => _watchlistMovieState;

  var _watchlistTvState = RequestState.Empty;
  RequestState get watchlistTvState => _watchlistTvState;

  String _message = '';
  String get message => _message;

  WatchlistMovieNotifier({required this.getWatchlistMovies, required this.getWatchListTvSeries});

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListTvSeries getWatchListTvSeries;

  Future<void> fetchWatchlistMovies() async {
    _watchlistMovieState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistMovieState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistMovieState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  String _messageTvSeries = '';
  String get messageTvSeries => _messageTvSeries;

  Future<void> fetchWatchlistTvSeries() async {
    _watchlistTvState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchListTvSeries.execute();
    result.fold(
          (failure) {
            _watchlistTvState = RequestState.Error;
            _messageTvSeries = failure.message;
        notifyListeners();
      },
          (tvSeriesData) {
            _watchlistTvState = RequestState.Loaded;
            _watchlistTvSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
