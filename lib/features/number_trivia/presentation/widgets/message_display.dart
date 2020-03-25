import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  const MessageDisplay({
    Key key,
    @required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          height: screenSize.height / 3,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
    );
  }
}
