import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/cupertino.dart';

class TvListNotifier extends ChangeNotifier {
  var _onAirTvShows = <Tv>[];
  List<Tv> get onAirTvShows => _onAirTvShows;

  var _popularTvSeries = <Tv>[];
  List<Tv> get popularTvSeries => _popularTvSeries;

  var _topRatedTvSeries = <Tv>[];
  List<Tv> get topRatedTvSeries => _topRatedTvSeries;

  RequestState _onAirState = RequestState.Empty;

  RequestState get onAirState => _onAirState;

  RequestState _popularState = RequestState.Empty;

  RequestState get popularState => _popularState;

  RequestState _topRatedTvState = RequestState.Empty;

  RequestState get topRatedTvState => _topRatedTvState;

  final GetOnAirTvShows getOnAirTvShows;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvListNotifier(
      {required this.getOnAirTvShows,
      required this.getPopularTvSeries,
      required this.getTopRatedTvSeries});

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAirTvShows() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAirTvShows.execute();
    result.fold(
      (failure) {
        _onAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _onAirState = RequestState.Loaded;
        _onAirTvShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvSeries() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularState = RequestState.Loaded;
        _popularTvSeries = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _topRatedTvState = RequestState.Loaded;
        _topRatedTvSeries = tvShowsData;
        notifyListeners();
      },
    );
  }
}
