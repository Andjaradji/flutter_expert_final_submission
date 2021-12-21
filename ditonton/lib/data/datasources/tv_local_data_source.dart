import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/watchlist_model.dart';

import 'db/database_helper.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlist(WatchlistModel tv);
  Future<String> removeWatchlist(WatchlistModel tv);
  Future<WatchlistModel?> getTvSeriesById(int id);
  Future<List<WatchlistModel>> getWatchlistTvSeries();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});


  @override
  Future<String> insertWatchlist(WatchlistModel tv) async {
    try {
      await databaseHelper.insertTvSeriesWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }


  @override
  Future<String> removeWatchlist(WatchlistModel tv) async {
    try {
      await databaseHelper.removeTvSeriesWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }



  @override
  Future<WatchlistModel?> getTvSeriesById(int id) async {
    final result = await databaseHelper.getTvSeriesById(id);
    if (result != null) {
      return WatchlistModel.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistModel>> getWatchlistTvSeries() async{
    final result = await databaseHelper.getWatchlistTvSeries();
    return result.map((data) => WatchlistModel.fromMap(data)).toList();
  }





}