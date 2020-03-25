import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TriviaControlsState();
  }
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: 'Input a number!',
          ),
          onChanged: (value) {
            setState(() {
              inputString = value;
            });
          },
          onSubmitted: (value) {
            _dispatchConcrete();
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('Search'),
                  textTheme: ButtonTextTheme.primary,
                  onPressed: _dispatchConcrete,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Random Trivia'),
                  onPressed: _dispatchRandom,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _dispatchConcrete() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaForConcreteNumber(numberString: inputString),
    );
  }

  void _dispatchRandom() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaForRandomNumber(),
    );
  }
}
