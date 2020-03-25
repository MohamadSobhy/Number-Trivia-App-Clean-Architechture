import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final int number;
  final String text;

  const TriviaDisplay({
    Key key,
    @required this.number,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          height: screenSize.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
