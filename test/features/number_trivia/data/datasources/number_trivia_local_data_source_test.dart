import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastFetchedNumberTrivia', () {
    test(
      'should return last cached NumberTrivia when there is one on preferences',
      () async {
        //arrange
        final tNumberTriviaModel = NumberTriviaModel.fromJson(
            json.decode(fixture('trivia_cached.json')));
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('trivia_cached.json'));
        //act
        final result = await dataSource.getLastFetchedNumberTrivia();
        //assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA_KEY));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw CacheException when there is no number trivia on preferences',
      () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //act
        final call = dataSource.getLastFetchedNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    test(
      'should cache NumberTriviaModel to preferences',
      () async {
        //arrange
        final tNumberTriviaModel =
            NumberTriviaModel(number: 1, text: 'Test Text');
        //act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);

        //assert
        verify(
          mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA_KEY,
            json.encode(tNumberTriviaModel.toJson()),
          ),
        );
      },
    );
  });
}
