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
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage('images/bg.png'),
                    fit: BoxFit.fill)),
            child: Padding(
                padding: EdgeInsets.all(50),
                child: ShareInherit(
                    answer: lenth,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8DFD6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 12, color: const Color(0xFFFF7720))),
                      child: Stack(children: _getDataSource()),
                    )))));
  }

  List<Widget> _getDataSource() {
    int ran = Random.secure().nextInt(pics.length - 1);
    List source = List.generate(lenth, (int index) {
      switch (content) {
        case GameCtx.ctxNum:
          return Random.secure().nextInt(89) + 10;
          break;
        case GameCtx.ctxStr:
          return words[Random.secure().nextInt(words.length - 1)];
          break;
        case GameCtx.ctxGraphic:
          return pics[Random.secure().nextInt(pics.length - 1)];
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
            return _QuestAnswer(lenth, ctx, widget.content);
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
  final GameCtx content;
  _QuestAnswer(this.answer, this.ctxx, this.content);
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
    return Scaffold(
      backgroundColor: Color(0x00),
      body: Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('images/bg.png'), fit: BoxFit.fill)),
          child: Column(children: <Widget>[
            SizedBox(height: 50),
            Text(_queStr(),
                style: TextStyle(fontSize: 20, color: Colors.white)),
            SizedBox(height: 30),
            Row(
              children: _getOptions(),
            ),
            SizedBox(height: 30),
            Offstage(
                offstage: right,
                child: Text('回答错误',
                    style: TextStyle(fontSize: 18, color: Colors.red))),
            Expanded(
              child: Stack(children: [
                Align(
                    alignment: Alignment(0.8, 0.6),
                    child: FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset('images/icon_back.png'),
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

  String _queStr() {
      String qstr;
      switch (widget.content) {
        case GameCtx.ctxNum:
          qstr = '请选择数字的数量';
          break;
        case GameCtx.ctxStr:
          qstr = '请选择文字的数量';
          break;
        default:
          qstr = '请选择图片的数量';
          break;
      }
      return qstr;
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
        activeColor: const Color(0xFFFF7720),
        value: childrens[idx],
        groupValue: groupValue,
        title: Text(
          '${childrens[idx]}',
          style: TextStyle(fontSize: 14, color: Colors.white),
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
