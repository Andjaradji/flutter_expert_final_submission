import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watch_list_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watch_list_tv_series.dart';
import 'package:flutter/material.dart';

import '../../common/state_enum.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_tv_detail.dart';
import '../../domain/usecases/get_tv_recommendations.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  late TvDetail _tvSeries;
  TvDetail get tvSeries => _tvSeries;

  late List<Tv> _tvRecommendations;
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvSeriesStatus getWatchListTvSeriesStatus;
  final SaveWatchListTvSeries saveWatchListTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvDetailNotifier({required this.getWatchListTvSeriesStatus,
    required this.saveWatchListTvSeries, required this.removeWatchlistTvSeries, required this.getTvDetail, required this.getTvRecommendations});

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
          (failure) {
            _tvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tv) {
        _recommendationState = RequestState.Loading;
        _tvSeries = tv;
        notifyListeners();
        recommendationResult.fold(
              (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
              (tvSeries) {
            _recommendationState = RequestState.Loaded;
            _tvRecommendations = tvSeries;
          },
        );
        _tvState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchListTvSeries.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }


  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlistTvSeries.execute(tv);

    await result.fold(
          (failure) async {
        _watchlistMessage = failure.message;
      },
          (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }




  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListTvSeriesStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }


}