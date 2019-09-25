/// 专注训练
///

import 'dart:async';
import 'dart:math';
import 'dart:ui';
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
  '黯',
  '籍',
  '蹲',
  '麓',
  '徙',
  '瞭',
  '黔'
];

class FocusTrain extends StatefulWidget {
  final int size;
  final GameCtx ctx;

  FocusTrain(this.size, this.ctx);
  FocusTrain.number({int size, GameCtx ctx}) : this(size, ctx);
  @override
  FocusTrainState createState() => FocusTrainState(size, ctx);
}

class FocusTrainState extends State<FocusTrain> {
  final GameCtx ctx;
  final int size;
  List<UnitContainer> _datasource;
  String rules;

  String numInfo;

  FocusTrainState(this.size, this.ctx) {
    _datasource =
        ctx == GameCtx.ctxNum ? _buildContextList() : _buildContextStrList();
    numInfo = ctx == GameCtx.ctxNum
        ? '游戏说明：请按0-${(size * size - 1).toString()}顺序消除数字'
        : '游戏说明：请按以下顺序消除文字';
    rules = words.sublist(0, size * size).join(' ');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _UnitContainerInher(
            source: ctx == GameCtx.ctxNum
                ? _getIntPool()
                : words.sublist(0, size * size),
            counted: 0,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: const AssetImage('images/bg.png'),
                        fit: BoxFit.fill)),
                child: Container(
                    padding: EdgeInsets.all(30),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFE8DFD6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                width: 12, color: const Color(0xFFFF7720))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('$numInfo',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                            Offstage(
                                offstage: ctx == GameCtx.ctxNum,
                                child: Text('$rules',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black))),
                            Container(
                              width: MediaQuery.of(context).size.height * 0.65,
                              height:
                                  MediaQuery.of(context).size.height * 0.65 + 25,
                              child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  crossAxisCount: size,
                                  children: _datasource),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Stack(
                              children: <Widget>[
                                Center(child: CountDownTimer(_timeLimit())),
                                Align(
                                  alignment: Alignment(0.8, 0),
                                  child: FlatButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Image.asset('images/icon_back.png'),
                                        SizedBox(width: 10),
                                        Text('退出训练',
                                            style: TextStyle(
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.none)),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ))))));
  }

  int _timeLimit() {
    int sec;
    switch (size) {
      case 3:
        sec = 15;
        break;
      case 4:
        sec = 25;
        break;
      case 5:
        sec = 45;
        break;
      case 6:
        sec = 85;
        break;
      case 7:
        sec = 165;
        break;
      case 8:
        sec = 325;
        break;
    }
    return sec;
  }

  List<int> _getIntPool() {
    List<int> pool = List<int>.generate(pow(size, 2), (int index) {
      return index;
    });
    return pool;
  }

  List<UnitContainer> _buildContextList() {
    List<int> pool = _getIntPool();
    List<UnitContainer> containers =
        List<UnitContainer>.generate(pow(size, 2), (int index) {
      int ran;
      do {
        ran = Random.secure().nextInt(size * size);
      } while (!pool.contains(ran));

      pool.remove(ran);
      return UnitContainer(
        random: ran,
        ctx: ctx,
      );
    });
    return containers;
  }

  List<UnitContainer> _buildContextStrList() {
    List pool = words.sublist(0, size * size);
    List<UnitContainer> containers =
        List<UnitContainer>.generate(pow(size, 2), (int index) {
      int ran;
      String str;
      do {
        ran = Random.secure().nextInt(size * size);
        str = words[ran];
      } while (!pool.contains(str));

      pool.remove(str);
      return UnitContainer(
        str: str,
        ctx: ctx,
      );
    });
    return containers;
  }
}

class UnitContainer extends StatefulWidget {
  final int random;
  final String str;
  final GameCtx ctx;
  UnitContainer({this.random, this.str, this.ctx}) : super();
  @override
  _UnitContainerState createState() => _UnitContainerState();
}

class _UnitContainerState extends State<UnitContainer> {
  bool visable = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                child: FlatButton(
              child: Text(
                  visable
                      ? ((widget.ctx == GameCtx.ctxNum)
                          ? widget.random.toString()
                          : widget.str)
                      : '',
                  style: TextStyle(fontSize: 15, color: Colors.red)),
              onPressed: _punchUnit,
            ))
          ],
        ));
  }

  void _punchUnit() {
    _UnitContainerInher inherContainer = _UnitContainerInher.of(context);
    List pool = inherContainer.source;
    int conted = inherContainer.counted;
    Timer timer = inherContainer.timer;
    var obj = (widget.ctx == GameCtx.ctxNum) ? widget.random : widget.str;

    if (pool.first == widget.random || pool.first == widget.str) {
      visable = false;
      pool.remove(obj);
      this.setState(() {});
    }
    if (pool.isEmpty) {
      timer.cancel();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Sucessed(over: true, score: conted, superCtx: context);
          });
    }
  }
}

class _UnitContainerInher extends InheritedWidget {
  static _UnitContainerInher of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_UnitContainerInher);
  List source;
  int counted;
  Timer timer;

  _UnitContainerInher(
      {Key key, this.source, this.counted, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_UnitContainerInher oldWidget) {
    return source != oldWidget.source;
  }
}

//定时器
class CountDownTimer extends StatefulWidget {
  final int _count;
  CountDownTimer(this._count);
  @override
  _CountDownTimerState createState() => _CountDownTimerState(_count);
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer _timer;
  int _count;

  _CountDownTimerState(this._count);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void didChangeDependencies() {
    _startCountDown();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.access_time), Text(_secondToStr(_count))],
      ),
    );
  }

  String _secondToStr(int second) {
    int min = second ~/ 60;
    int sec = second % 60;
    return '${min.toString()}:${sec.toString()}';
  }

  void _startCountDown() {
    const oneSec = const Duration(seconds: 1);
    _UnitContainerInher inherContainer = _UnitContainerInher.of(context);

    var callback = (Timer timer) => {
          this.setState(() {
            if (_count < 1) {
              timer.cancel();
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext ctx) {
                    print(ctx.widget);
                    return Sucessed(
                      over: false,
                      superCtx: context,
                    );
                  });
            } else {
              _count -= 1;
              inherContainer.counted += 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
    inherContainer.timer = _timer;
  }
}

class Sucessed extends StatelessWidget {
  final bool over;
  final int score;
  final BuildContext superCtx;
  Sucessed({this.over, this.score, this.superCtx});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 400,
      height: 400,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(over ? '用时：${score.toString()}秒\n太棒了！' : '胜败乃兵家常事，再接再厉',
              style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  backgroundColor: Colors.white)),
          Padding(padding: EdgeInsets.all(10)),
          MaterialButton(
            child: Text('返回上层'),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(superCtx).pop();
            },
          )
        ],
      ),
    ));
  }
}
