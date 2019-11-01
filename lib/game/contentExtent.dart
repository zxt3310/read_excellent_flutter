import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';

const List<String> words = [
  '可',
  '壤',
  '露',
  '央',
  '籍',
  '攀',
  '然',
  '理',
  '接',
  '着',
  '落',
  '从',
  '本',
  '心',
  '熟',
  '衡',
  '融',
  '甲',
  '乃',
  '与',
  '凝',
  '同',
  '繁',
  '躁',
  '国',
  '年',
  '如',
  '十',
  '个',
  '蠡',
  '黯',
  '矗',
  '灝',
  '昧',
  '眨',
  '仔',
  '白',
  '题',
  '篇',
  '入',
  '卜',
  '点',
  '俪',
  '总',
  '揽',
  '亲',
  '言',
  '覆',
  '圭',
  '达',
  '训',
  '各',
  '考',
  '馕',
  '得',
  '颧',
  '霾',
  '贺',
  '籍',
  '蹲',
  '麓',
  '徙',
  '瞭',
  '黔'
];

class ContentContainor extends StatelessWidget {
  final GameCtx ctx;
  final int range;
  final GameMode mode;
  const ContentContainor({Key key, this.ctx, this.range, this.mode})
      : super(key: key);

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
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 12, color: const Color(0xFFFF7720))),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment(0, 0.5),
                              child: ContentExtentView(ctx: ctx, range: range, mode: mode),
                            ),
                            Align(
                              alignment: Alignment(0.8, 0.9),
                              child:FlatButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset('images/icon_back.png'),
                                  SizedBox(width: 10),
                                  Text('返回',
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
                      ),
                      )
                    ],
                  ),
                ))));
  }
}

class ContentExtentView extends StatefulWidget {
  final GameCtx ctx;
  final int range;
  final GameMode mode;
  ContentExtentView({Key key, this.ctx, this.range, this.mode})
      : super(key: key);

  @override
  _ContentExtentViewState createState() => _ContentExtentViewState();
}

class _ContentExtentViewState extends State<ContentExtentView> {
  Timer timer;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(contentStr(),
            style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                decoration: TextDecoration.none)),
      ),
    );
  }

  String contentStr() {
    List contentAry = List.generate(widget.range, (idx) {
      if (widget.ctx == GameCtx.ctxNum) {
        int num = Random.secure().nextInt(9);
        return '$num';
      } else if (widget.ctx == GameCtx.ctxStr) {
        int index = Random.secure().nextInt(words.length - 1);
        return words[index];
      }
    });

    return contentAry.sublist(0, widget.range).join('');
  }

  @override
  void initState() {
    super.initState();
    this.startTrain();
  }

  void startTrain() {
    var callBack = (timer) {
      this.setState(() {});
    };
    var unitSec = Duration(milliseconds: (widget.mode.index * 250 + 500));
    timer = Timer.periodic(unitSec, callBack);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
