import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

import '../../common/failure.dart';
import '../entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnTheAirTvShows();
  Future<Either<Failure, List<Tv>>> getPopularTvSeries();
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries();

}