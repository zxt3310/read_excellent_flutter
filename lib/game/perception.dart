import 'dart:math';

///感知训练
import '../Tools/UIDefine.dart';
import 'package:flutter/material.dart';

class PerceptionTrain extends StatefulWidget {
  final GameMode mode;
  final GameCtx content;

  PerceptionTrain({this.mode, this.content});

  @override
  _PerceptionTrainState createState() => _PerceptionTrainState(mode, content);
}

class _PerceptionTrainState extends State<PerceptionTrain> {
  final GameMode mode;
  final GameCtx content;

  _PerceptionTrainState(this.mode, this.content);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child:Container(
            color: Colors.yellow,
            child: Stack(
              children: _getDataSource()
            ),
          )
        ),
      )
    );
  }

  List <Widget> _getDataSource() {
    int lenth = Random.secure().nextInt(8) + 4;
    List source = List.generate(lenth, (int index) {
      switch (content) {
        case GameCtx.ctxNum:
          return Random.secure().nextInt(89) + 10;
          break;
        case GameCtx.ctxStr:
          break;
        case GameCtx.ctxGraphic:
          break;
        default:
      }
    });

    return List.generate(lenth, (int idx){
      double top = Random.secure().nextDouble()*2-1; //* (height- 20);
      double left = Random.secure().nextDouble()*2-1; //* (width - 40);

      return Align(
            alignment: Alignment(top,left),//AlignmentDirectional(0.8, -0.8),
            child: Container(
              width: 40,
              height: 20,
              child: Center(
                child: Text('${source[idx]}',style: TextStyle(fontSize: 18,decoration: TextDecoration.none)),
              ),
          ),
        );
    });
  }
}
