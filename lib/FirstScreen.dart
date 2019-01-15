import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Text(
          'first page',
          style: new TextStyle(fontSize: 20, color: Colors.amber),
        ),
      ),
    );
  }
}
