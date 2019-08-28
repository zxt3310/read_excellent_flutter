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
  int size;
  List<String> strs;
  List<UnitContainer> datasource;

  FocusTrainState(this.size, this.strs) {
    datasource = _buildContextList();
  }
  @override
  Widget build(BuildContext context) {
    // if (size > 0) {
    return Scaffold(
        body: Center(
            child: Container(
      width: 250,
      height: 250,
      child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          crossAxisCount: size,
          children: datasource),
    )));
    //}
  }

  List<UnitContainer> _buildContextList() {
    List<int> pool = List<int>.generate(pow(size, 2), (int index) {
      return index;
    });
    List<UnitContainer> containers =
        List<UnitContainer>.generate(pow(size, 2), (int index) {
      int ran;
      do {
        ran = Random.secure().nextInt(size * size);
      } while (!pool.contains(ran));

      pool.remove(ran);
      return UnitContainer(ran + 1);
    });
    return containers;
  }
}

class UnitContainer extends StatefulWidget {
  final int random;
  UnitContainer(this.random) : super();
  @override
  _UnitContainerState createState() => _UnitContainerState(random);
}

class _UnitContainerState extends State<UnitContainer> {
  int ran;
  bool visable = true;

  _UnitContainerState(this.ran) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
          child: FlatButton(
        padding: EdgeInsets.all(5),
        child: Text(visable ? ran.toString() : '',
            style: TextStyle(fontSize: 15, color: Colors.red)),
        onPressed: _punchUnit,
      )),
    );
  }

  void _punchUnit() {
    visable = false;
    this.setState((){});
  }
}
