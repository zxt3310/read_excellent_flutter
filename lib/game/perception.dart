import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';

///感知训练
import '../Tools/UIDefine.dart';
import 'package:flutter/material.dart';

EventBus eventBus = new EventBus();

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
  BuildContext ctxx;

  int lenth;
  Timer _timer;

  _PerceptionTrainState(this.mode, this.content);
  @override
  Widget build(BuildContext context) {
    ctxx = context;
    lenth = Random.secure().nextInt(8) + 4;
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: ShareInherit(
                    answer: lenth,
                    child: Container(
                      color: Colors.yellow,
                      child: Stack(children: _getDataSource()),
                    )))));
  }

  List<Widget> _getDataSource() {
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

    return List.generate(lenth, (int idx) {
      double top = Random.secure().nextDouble() * 2 - 1; //* (height- 20);
      double left = Random.secure().nextDouble() * 2 - 1; //* (width - 40);

      return Align(
        alignment: Alignment(top, left), //AlignmentDirectional(0.8, -0.8),
        child: Container(
          width: 40,
          height: 20,
          child: Center(
            child: Text('${source[idx]}',
                style:
                    TextStyle(fontSize: 18, decoration: TextDecoration.none)),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    eventBus.destroy();
  }

  void startCount(GameMode curMode) {
    int sec = curMode.index + 1;

    var second = Duration(seconds: sec);
    var callBack = (Timer tm) {
      tm.cancel();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext ctx) {
            return _QuestAnswer(lenth);
          });
    };

    _timer = Timer.periodic(second, callBack);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCount(mode);
    eventBus.on<CustomEvent>().listen((event){
      setState((){});
    });
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    startCount(mode);
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

class _QuestAnswer extends StatefulWidget {
  final int answer;
  _QuestAnswer(this.answer);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;

  List childrens;
  _QuestAnswerState(this.answer);

  int groupValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
          child: Column(children: <Widget>[
        Text('请选择数字的个数', style: TextStyle(fontSize: 16)),
        Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: _getOptions(),
        )
      ])),
    );
  }

  List _getEnumAry() {
    List source;
    do {
      source = List.generate(4, (int idx) {
        return Random.secure().nextInt(8) + 4;
      });
    } while (!source.contains(answer));
    return source;
  }

  List<Widget> _getOptions() {
    List<Widget> res = List.generate(4, (int idx) {
      return Flexible(
          child: RadioListTile(
        value: childrens[idx],
        groupValue: groupValue,
        title: Text(
          '${childrens[idx]}',
          style: TextStyle(fontSize: 14),
        ),
        onChanged: (value) {
          this.setState(() {
            groupValue = childrens[idx];
            if (groupValue == answer) {
              Navigator.of(context).pop();
              eventBus.fire(CustomEvent());
            }
          });
        },
      ));
    });
    return res;
  }

  @override
  void didChangeDependencies() {
    childrens = _getEnumAry();
    super.didChangeDependencies();
  }
}
//通知
class CustomEvent {
  CustomEvent();
}

