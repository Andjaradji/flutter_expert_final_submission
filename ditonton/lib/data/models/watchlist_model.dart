import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class WatchlistModel extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  WatchlistModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory WatchlistModel.fromMovieEntity(MovieDetail movie) => WatchlistModel(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
      );

  factory WatchlistModel.fromTvEntity(TvDetail tv) => WatchlistModel(
    id: tv.id,
    title: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
  );

  factory WatchlistModel.fromMap(Map<String, dynamic> map) => WatchlistModel(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
      };

  Movie toMovieEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  Tv toTvEntity() => Tv.watchlist(
    id: id,
    overview: overview,
    posterPath: posterPath,
    name: title,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
