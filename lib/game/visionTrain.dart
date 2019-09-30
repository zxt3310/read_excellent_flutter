import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../Tools/UIDefine.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class Vision extends StatefulWidget {
  final GamePath path;
  final GameMode mode;
  Vision({this.path, this.mode});
  @override
  _VisionState createState() => _VisionState(path, mode);
}

class _VisionState extends State<Vision> {
  final GamePath path;
  final GameMode mode;
  int cout = 7;
  Timer _timer;
  //答案
  int answer = 0;
  //目标图形
  Widget target;
  List<Image> datalists;

  _VisionState(this.path, this.mode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            children: _dataSource(),
          ),
        ),
      ),
    ));
  }

  List<Widget> _dataSource() {
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
    datalists = List.generate(8, (int index) {
      return pics[Random.secure().nextInt(pics.length - 1)];
    });
    target = datalists[Random.secure().nextInt(7)];
    answer = 0;
    for (Image obj in datalists) {
      if (obj == target) {
        answer++;
      }
    }
    // if (path != GamePath.pathX) {
    return List<Widget>.generate(8, (int idx) {
      double x = -0.75 + idx ~/ 2 * 0.5;
      double y = (idx % 2 == 0) ? -0.75 : 0.75;

      if (widget.path == GamePath.pathZ) {
        double t = x;
        x = y;
        y = t;
      }

      return Align(
          child: _UnitView(icon: datalists[idx], index: idx),
          alignment: Alignment(x, y));
    });
    // }
    // return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startGame();
  }

  StreamSubscription subscription;

  @override
  void initState() {
    subscription = eventBus.on<ResetNotify>().listen((evnet) {
      this.setState(() {
        cout = 7;
      });
    });
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
    _startGame();
  }

  @override
  void dispose() {
    _timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  void _startGame() {
    var callBack = (Timer timer) {
      if (cout < -1) {
        timer.cancel();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext ctx) {
              return _QuestAnswer(answer, context, target);
            });
      } else {
        eventBus.fire(FreshEvent((7 - cout), datalists));
        cout -= 1;
      }
    };

    var oneSec = Duration(milliseconds: widget.mode.index*250 + 500);
    _timer = Timer.periodic(oneSec, callBack);
  }
}

class _UnitView extends StatefulWidget {
  final Image icon;
  final int index;
  _UnitView({this.icon, this.index});
  @override
  _UnitViewState createState() => _UnitViewState(icon, index);
}

class _UnitViewState extends State<_UnitView> {
  Image icon;
  final int index;
  bool hide = true;
  _UnitViewState(this.icon, this.index);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: hide,
      child: Container(
        width: 60,
        height: 60,
        child: Center(
          child: icon,
        ),
      ),
    );
  }

  StreamSubscription subscription;
  @override
  void initState() {
    subscription = eventBus.on<FreshEvent>().listen((event) {
      setState(() {
        hide = event.current == index ? false : true;
        icon = event.datalist[index];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

//弹窗

class _QuestAnswer extends StatefulWidget {
  final int answer;
  final BuildContext ctxx;
  final Image target;
  _QuestAnswer(this.answer, this.ctxx, this.target);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer, ctxx, target);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;
  final BuildContext ctxx;

  List childrens;
  final Image target;
  bool right = true;
  _QuestAnswerState(this.answer, this.ctxx, this.target);

  int groupValue;
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
            SizedBox(height: 30),
            target,
            SizedBox(
              height: 10,
            ),
            Text('请选择上面图形的出现次数',
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
                          Text('返回', style: TextStyle(fontSize: 14)),
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

  //生成选项内容
  List _getEnumAry() {
    List source;
    do {
      do {
        source = List.generate(4, (int idx) {
          return Random.secure().nextInt(7) + 1;
        });
      } while (!source.contains(answer));
    } while (Set.from(source).length < 4);
    return source;
  }

  //四个选项
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
              eventBus.fire(ResetNotify());
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
class FreshEvent {
  int current;
  List<Image> datalist;
  FreshEvent(this.current, this.datalist);
}

class ResetNotify {
  ResetNotify();
}
