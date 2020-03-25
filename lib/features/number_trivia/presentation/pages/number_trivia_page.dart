import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      builder: (_) => servLocator<NumberTriviaBloc>(),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaInitialState) {
                    return MessageDisplay(message: 'Start Searching!');
                  } else if (state is NumberTriviaLoadedState) {
                    return TriviaDisplay(
                      number: state.trivia.number,
                      text: state.trivia.text,
                    );
                  } else if (state is ErrorState) {
                    return MessageDisplay(message: state.message);
                  } else if (state is LoadingState) {
                    return LoadingWidget();
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
