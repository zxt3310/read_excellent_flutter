import 'dart:math';

import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';

class ContentContainor extends StatelessWidget {
  final GameCtx ctx;
  final int range;
  const ContentContainor({Key key,this.ctx,this.range}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('images/bg.png'),
                    fit: BoxFit.fill)),
            child: Padding(
                padding: EdgeInsets.all(50),
                child: ShareInherit(
                    answer: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 12, color: const Color(0xFFFF7720))),
                      child: null,
                    )))));
  }
}



class ShareInherit extends InheritedWidget {
  final int answer;

  static ShareInherit of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ShareInherit);

  ShareInherit({Key key, @required Widget child, this.answer})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}