import 'dart:async';
import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';

class VistaTrain extends StatelessWidget {
  final RectShape shape;
  final GameMode mode;
  VistaTrain({this.shape, this.mode});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('images/bg.png'), fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFE8DFD6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 12, color: const Color(0xFFFF7720))),
            child: Stack(
              children: <Widget>[
                Center(
                  child: VistaRect(shape, mode),
                ),
                Align(
                  alignment: Alignment(0.8, 0.85),
                  child: FlatButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('images/icon_back.png'),
                        SizedBox(width: 10),
                        Text('退出训练',
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.none)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class VistaRect extends StatefulWidget {
  final RectShape shape;
  final GameMode mode;
  VistaRect(this.shape, this.mode);
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
                borderRadius: widget.shape == RectShape.shapeCycle
                    ? BorderRadius.circular(dr / 2)
                    : BorderRadius.circular(0))
            : BoxDecoration(),
        child: Center(
          child: Container(
            width: cdr,
            height: cdr,
            decoration: BoxDecoration(
                color: const Color(0xFFF99A2f),
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
        this.setState(() {});
      } else {
        dr = count * 8 * cdr;
        count += 1;
        this.setState(() {});
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
