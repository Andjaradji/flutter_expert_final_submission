import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;


import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main () {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On Air Tv Shows',(){
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_model_dummy.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_model_dummy.json'), 200));
          // act
          final result = await dataSource.getOnAirTvShows();
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getOnAirTvShows();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });

  });

  group('get Popular Tv Shows',(){
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_model_dummy.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_model_dummy.json'), 200));
          // act
          final result = await dataSource.getPopularTvSeries();
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });

  });

  group('get Top Rated Tv Shows',(){
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_model_dummy.json')))
        .tvList;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_model_dummy.json'), 200));
          // act
          final result = await dataSource.getTopRatedTvSeries();
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });

  });


  group('get Detail of Tv Series',(){
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail_model_dummy.json')));

    final id = 1969;

    test('should return Tv Detail Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$id?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail_model_dummy.json'), 200));
          // act
          final result = await dataSource.getTvSeriesDetail(id);
          // assert
          expect(result, equals(tTvDetail));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$id?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvSeriesDetail(id);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });

  });

  group('get Tv Recommendations',(){
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_recommendations_dummy.json')))
        .tvList;

    final id = 1969;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_recommendations_dummy.json'), 200));
          // act
          final result = await dataSource.getTvRecommendations(id);
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvRecommendations(id);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
    
  });
  group('search Tv series',(){
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/search_squid_game_tv_series.json')))
        .tvList;

    final tQuery = "Squid Game";

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_squid_game_tv_series.json'), 200));
          // act
          final result = await dataSource.searchTvSeries(tQuery);
          // assert
          expect(result, equals(tTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTvSeries(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });

  });






}