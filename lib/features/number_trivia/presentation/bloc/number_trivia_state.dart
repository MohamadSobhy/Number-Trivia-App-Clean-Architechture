part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class NumberTriviaInitialState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoadedState({@required this.trivia}) : super([trivia]);
}

class ErrorState extends NumberTriviaState {
  final String message;

  ErrorState({@required this.message}) : super([message]);
}
