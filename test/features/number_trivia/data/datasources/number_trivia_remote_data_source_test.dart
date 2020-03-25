import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  setUpHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  setUpHttpClientFailures404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 400));
  }

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform GET request to api with random endpoint',
      () async {
        //arrange
        setUpHttpClientSuccess200();
        //act
        remoteDataSource.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get(
          'http://www.numbersapi/random',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTriviaModel with relevant data when response code is 200',
      () async {
        //arrange
        setUpHttpClientSuccess200();
        //act
        final result = await remoteDataSource.getRandomNumberTrivia();
        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException for any error codes',
      () async {
        //arrange
        setUpHttpClientFailures404();
        //act
        final call = remoteDataSource.getRandomNumberTrivia;
        //assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform GET request to api with number endpoint',
      () async {
        //arrange
        setUpHttpClientSuccess200();
        //act
        remoteDataSource.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get(
          'http://www.numbersapi/$tNumber',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTriviaModel with relevant data when response code is 200',
      () async {
        //arrange
        setUpHttpClientSuccess200();
        //act
        final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw ServerException for any error codes',
      () async {
        //arrange
        setUpHttpClientFailures404();
        //act
        final call = remoteDataSource.getConcreteNumberTrivia;
        //assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
