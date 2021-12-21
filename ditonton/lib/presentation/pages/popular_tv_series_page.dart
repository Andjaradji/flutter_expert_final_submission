import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/list-tv-series';
  final bool isPopular;

  const ListTvSeriesPage(this.isPopular);

  @override
  _ListTvSeriesPageState createState() => _ListTvSeriesPageState();
}

class _ListTvSeriesPageState extends State<ListTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    widget.isPopular
        ? Future.microtask(() =>
            Provider.of<TvListNotifier>(context, listen: false)
                .fetchPopularTvSeries())
        : Future.microtask(() =>
            Provider.of<TvListNotifier>(context, listen: false)
                .fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPopular ? 'Popular Tv Series' : 'Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvListNotifier>(
          builder: (context, data, child) {
            var state =
                widget.isPopular ? data.popularState : data.topRatedTvState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = widget.isPopular
                      ? data.popularTvSeries[index]
                      : data.topRatedTvSeries[index];
                  return TvCard(tv);
                },
                itemCount: widget.isPopular
                    ? data.popularTvSeries.length
                    : data.topRatedTvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
