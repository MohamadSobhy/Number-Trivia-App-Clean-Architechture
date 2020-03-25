import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('unsignedIntegerFromString', () {
    test(
      'should return unsigned integer from string input',
      () async {
        //arrange
        final numberString = '123';
        //act
        final result = inputConverter.unsignedIntegerFromString(numberString);
        //assert
        expect(result, Right(123));
      },
    );

    test(
      'should return InvalidInputFailure when trying to parse invalid string input',
      () async {
        //arrange
        final numberString = '123k';
        //act
        final result = inputConverter.unsignedIntegerFromString(numberString);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return InvalidInputFailure when the number is negative',
      () async {
        //arrange
        final numberString = '-123';
        //act
        final result = inputConverter.unsignedIntegerFromString(numberString);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
