import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () {
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is a double',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a json map of the NumberTriviaModel',
      () async {
        //arrange
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };

        //act
        final result = tNumberTriviaModel.toJson();

        //assert
        expect(result, expectedMap);
      },
    );
  });
}
