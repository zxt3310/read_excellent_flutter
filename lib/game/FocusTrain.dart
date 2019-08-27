import 'package:flutter/material.dart';

class FocusTrain extends StatefulWidget {
  final int size;
  FocusTrain(this.size):super();
  @override
  FocusTrainState createState() => FocusTrainState(size);
}

class FocusTrainState extends State<FocusTrain> {
  int size;
  FocusTrainState(this.size):super();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          
      ),
    );
  }
}