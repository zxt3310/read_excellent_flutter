import 'dart:async';
import 'package:flutter/material.dart';
import 'package:read_excellent/Tools/UIDefine.dart';

class VistaTrain extends StatelessWidget {
  final RectShape shape;
  final GameMode mode;
  VistaTrain({this.shape,this.mode});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
            color: Colors.yellowAccent,
            child: Center(
              child: VistaRect(shape,mode),
            )),
      ),
    );
  }
}

class VistaRect extends StatefulWidget {
  final RectShape shape;
  final GameMode mode;
  VistaRect(this.shape,this.mode);
  @override
  _VistaRectState createState() => _VistaRectState();
}

class _VistaRectState extends State<VistaRect> {
  double dr = 20;
  double cdr = 20;
  Timer _timer;
  int count = 1;
  @override
  Widget build(BuildContext context) {
    print(dr);
    return Container(
        width: dr,
        height: dr,
        decoration: dr > 20
            ? BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius:widget.shape == RectShape.shapeCycle?BorderRadius.circular(dr / 2):BorderRadius.circular(0))
            : BoxDecoration(),
        child: Center(
          child: Container(
            width: cdr,
            height: cdr,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(cdr / 2)),
          ),
        ));
  }

  void startVis() {
    var oneSec = Duration(seconds: widget.mode.index + 1);
    var callBack = (timer) {
      if (count == 4) {
        dr = cdr;
        count = 1;
        this.setState((){});
      }else{
        dr = count * 8 * cdr;
        count +=1;
        this.setState((){});
      }
    };

   _timer = Timer.periodic(oneSec, callBack);
  }

  @override
  void initState() {
    super.initState();
    startVis();
  }
  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
}
