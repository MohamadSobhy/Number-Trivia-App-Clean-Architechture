import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  ///returns the last fetched [NumberTriviaModel] which was gotten the last time
  ///the user had an internet connection
  ///
  ///Throws [CacheException] if no cached data found
  Future<NumberTriviaModel> getLastFetchedNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const String CACHED_NUMBER_TRIVIA_KEY = 'CACHED_NUMBER_TRIVIA_KEY';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastFetchedNumberTrivia() {
    final triviaJson = sharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY);
    if (triviaJson != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(triviaJson)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA_KEY, json.encode(triviaToCache.toJson()));
  }
}
