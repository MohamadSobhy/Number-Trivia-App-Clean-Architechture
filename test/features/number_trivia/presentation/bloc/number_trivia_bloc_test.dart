import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('bloc.initial state should be NumberTriviaInitialState', () {
    expect(bloc.initialState, NumberTriviaInitialState());
  });

  group('getTriviaForConcreteNumber', () {
    final String tNumberString = '1';
    final int tParsedNumber = 1;
    final NumberTrivia tNumberTrivia =
        NumberTrivia(text: 'Test Trivia', number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.unsignedIntegerFromString(any))
          .thenReturn(Right(tParsedNumber));
    }

    test(
      'should call unsignedIntegerFromString method from InputConverter class',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(
            mockInputConverter.unsignedIntegerFromString(tNumberString));
        //assert
        verify(mockInputConverter.unsignedIntegerFromString(tNumberString));
      },
    );

    test(
      'should emit [ErrorState] if the numberString if the event is invalid',
      () async {
        //arrange
        when(mockInputConverter.unsignedIntegerFromString(any))
            .thenReturn(Left(InvalidInputFailure()));
        //assert
        final expected = [
          NumberTriviaInitialState(),
          ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );

    test(
      'should return data when getConcreteNumberTrivia usecase called',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));

        //assert
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          NumberTriviaLoadedState(trivia: tNumberTrivia),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
      },
    );

    test(
      'should emit [ErrorState] when getConcreteNumberTrivia usecase returns [SereverFailure]',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert Later
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );

    test(
      'should emit [ErrorState] when getConcreteNumberTrivia usecase returns [CacheFailure]',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        //assert Later
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(numberString: tNumberString));
      },
    );
  });

  group('getTriviaForRandomNumber', () {
    final NumberTrivia tNumberTrivia =
        NumberTrivia(text: 'Test Trivia', number: 1);

    test(
      'should return data when getRandomNumberTrivia usecase called',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForRandomNumber());

        //assert
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          NumberTriviaLoadedState(trivia: tNumberTrivia),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
      },
    );

    test(
      'should emit [ErrorState] when getRandomNumberTrivia usecase returns [SereverFailure]',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert Later
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          ErrorState(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [ErrorState] when getRandomNumberTrivia usecase returns [CacheFailure]',
      () async {
        //arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        //assert Later
        final expected = [
          NumberTriviaInitialState(),
          LoadingState(),
          ErrorState(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(
          bloc.state,
          emitsInOrder(expected),
        );
        //act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
