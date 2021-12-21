import '../repositories/tv_repository.dart';

class GetWatchListTvSeriesStatus {
  final TvRepository repository;

  GetWatchListTvSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
