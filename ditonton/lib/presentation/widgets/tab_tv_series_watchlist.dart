import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/state_enum.dart';
import '../provider/watchlist_movie_notifier.dart';
import 'tv_card_list.dart';

class TabTvSeriesWatchList extends StatelessWidget {
  const TabTvSeriesWatchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 12.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistTvState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistTvState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = data.watchlistTvSeries[index];
                return TvCard(tv);
              },
              itemCount: data.watchlistTvSeries.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.messageTvSeries),
            );
          }
        },
      ),
    );
  }
}
