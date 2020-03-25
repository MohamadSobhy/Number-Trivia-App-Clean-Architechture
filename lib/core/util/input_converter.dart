import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> unsignedIntegerFromString(String numberString) {
    try {
      final parsedNumber = int.parse(numberString);

      if (parsedNumber < 0) throw FormatException();

      return Right(parsedNumber);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
