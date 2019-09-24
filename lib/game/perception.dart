import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';

///感知训练
import '../Tools/UIDefine.dart';
import 'package:flutter/material.dart';

List<Image> pics = [
  Image.asset('images/棒冰.png'),
  Image.asset('images/爆米花.png'),
  Image.asset('images/开心果.png'),
  Image.asset('images/马卡龙.png'),
  Image.asset('images/热狗.png'),
  Image.asset('images/寿司.png'),
  Image.asset('images/甜甜圈.png'),
  Image.asset('images/饼干.png')
];

List<String> words = [
  '浏览',
  '诠释',
  '憧憬',
  '萤火',
  '梦幻',
  '精美',
  '弥漫',
  '湍急',
  '酣睡',
  '嘈杂',
  '巍然',
  '屹立',
  '蓦地',
  '摒弃',
  '迸溅',
  '和蔼',
  '惆怅',
  '豁达',
  '清澈',
  '赋予',
  '濒危',
  '钦佩',
  '欣赏',
  '讨论',
  '愉悦',
  '明朗',
  '简单',
  '检查',
  '坚持',
  '善良',
  '祖国',
  '喜欢',
  '观察',
  '偏袒',
  '拘束',
  '冒昧',
  '博弈',
  '馈赠',
  '倦怠',
  '贪婪',
  '憔悴',
  '权衡',
  '淳朴',
  '佯攻',
  '渎职',
  '戒备',
  '迂回',
  '玷污',
  '异议',
  '妄想',
  '腐朽',
  '瑕疵',
  '乔装',
  '诙谐',
  '安全',
  '精湛'
];

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

  int lenth;
  Timer _timer;

  _PerceptionTrainState(this.mode, this.content);
  @override
  Widget build(BuildContext context) {
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
    int ran = Random.secure().nextInt(pics.length-1);
    List source = List.generate(lenth, (int index) {
      switch (content) {
        case GameCtx.ctxNum:
          return Random.secure().nextInt(89) + 10;
          break;
        case GameCtx.ctxStr:
          return words[Random.secure().nextInt(words.length-1)];
          break;
        case GameCtx.ctxGraphic:
          return pics[Random.secure().nextInt(pics.length-1)];
          break;
        case GameCtx.ctxGraphicUnion:
          return pics[ran];
        default:
      }
      return null;
    });

    return List.generate(lenth, (int idx) {
      double top = Random.secure().nextDouble() * 2 - 1; //* (height- 20);
      double left = Random.secure().nextDouble() * 2 - 1; //* (width - 40);

      return Align(
        alignment: Alignment(top, left), //AlignmentDirectional(0.8, -0.8),
        child: Container(
          width: 40,
          height: 40,
          child: Center(
            child: (widget.content == GameCtx.ctxGraphic ||
                    widget.content == GameCtx.ctxGraphicUnion)
                ? source[idx]
                : Text('${source[idx]}',
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.none)),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    subscription.cancel();
    super.dispose();
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
            return _QuestAnswer(lenth, ctx);
          });
    };

    _timer = Timer.periodic(second, callBack);
  }

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    startCount(mode);
    subscription = eventBus.on<CustomEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
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
  final BuildContext ctxx;
  _QuestAnswer(this.answer, this.ctxx);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer, ctxx);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;
  final BuildContext ctxx;

  List childrens;
  _QuestAnswerState(this.answer, this.ctxx);

  int groupValue;

  bool right = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
          child: Column(children: <Widget>[
        SizedBox(height: 50),
        Text('请选择数字的个数', style: TextStyle(fontSize: 20)),
        SizedBox(height: 30),
        Row(
          children: _getOptions(),
        ),
        SizedBox(height: 30),
        Offstage(
          offstage: right,
          child: Text('回答错误', style: TextStyle(fontSize: 18,color: Colors.red))
        ),
        Expanded(
          child: Stack(children: [
            Align(
                alignment: Alignment(0.8, 0.6),
                child: FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.backspace),
                      SizedBox(width: 10),
                      Text('退出训练', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(ctxx).pop();
                  },
                ))
          ]),
        )
      ])),
    );
  }

  List _getEnumAry() {
    List source;
    do {
      do {
        source = List.generate(4, (int idx) {
          return Random.secure().nextInt(8) + 4;
        });
      } while (!source.contains(answer));
    } while (Set.from(source).length < 4);
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
            right = groupValue == answer;
            if (right) {
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
