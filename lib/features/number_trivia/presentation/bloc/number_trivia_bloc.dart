import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/usecases/usecase.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Input Failure - the number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => NumberTriviaInitialState();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final result =
          inputConverter.unsignedIntegerFromString(event.numberString);

      yield* result.fold(
        (failure) async* {
          yield ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (number) async* {
          yield LoadingState();
          final triviaEither =
              await getConcreteNumberTrivia(Params(number: number));

          yield* _eitherLoadedOrErrorState(triviaEither);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield LoadingState();
      final triviaEither = await getRandomNumberTrivia(NoParams());

      yield* _eitherLoadedOrErrorState(triviaEither);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> triviaEither,
  ) async* {
    yield triviaEither.fold(
        (failure) => ErrorState(message: _mapFailureToMessage(failure)),
        (numberTrivia) => NumberTriviaLoadedState(trivia: numberTrivia));
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
