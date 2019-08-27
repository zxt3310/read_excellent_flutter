import 'dart:math';
import 'package:flutter/material.dart';

class FocusTrain extends StatefulWidget {
  final int size;
  final List<String> strs;

  FocusTrain(this.size, this.strs);
  FocusTrain.number(int x) : this(x, null);
  FocusTrain.strAry(List<String> ary) : this(null, ary);
  @override
  FocusTrainState createState() => FocusTrainState(size, strs);
}

class FocusTrainState extends State<FocusTrain> {
  final int size;
  final List<String> strs;

  FocusTrainState(this.size, this.strs) : super();
  @override
  Widget build(BuildContext context) {
    if (size > 0) {
      return Scaffold(
        body:Center(
          child: Container(
            width: 250,
            height: 250,
            child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: size,
            children: _buildContextList()
          ),
          )
        )
      );
    }
  }

  List<Container> _buildContextList(){
    List<Container> containers = List<Container>.generate(
      size*size, 
      (int index){
        return Container(
          //color: Colors.white,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black,width: 1),
          ),
          child: Center(child: Text(index.toString(),style: TextStyle(fontSize: 15,color: Colors.red))
          ),
        );
    });
    return containers;
  }
}
