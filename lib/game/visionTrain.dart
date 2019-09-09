import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:read_excellent/Tools/UIDefine.dart';
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

  List<Icon>datalists;

  _VisionState(this.path, this.mode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Container(
          color: Colors.yellowAccent,
          child: Stack(
            children: _dataSource(),
          ),
        ),
      ),
    );
  }

  List<Widget> _dataSource() {
    List<Icon> pics = [
      Icon(Icons.account_balance_wallet),
      Icon(Icons.add_photo_alternate),
      Icon(Icons.airline_seat_legroom_reduced),
      Icon(Icons.battery_charging_full)
    ];
    datalists = List.generate(8, (int index) {
      return pics[Random.secure().nextInt(pics.length - 1)];
    });
    target = datalists[Random.secure().nextInt(7)];
    answer = 0;
    for (Icon obj in datalists) {
      if (obj == target) {
        answer++;
      }
    }

    // if (path != GamePath.pathX) {
    return List<Widget>.generate(8, (int idx) {
      double x = -0.75 + idx ~/ 2 * 0.5;
      double y = (idx % 2 == 0) ? -0.75 : 0.75;

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
        eventBus.fire(FreshEvent((7 - cout),datalists));
        cout -= 1;
      }
    };

    var oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(oneSec, callBack);
  }
}

class _UnitView extends StatefulWidget {
  final Icon icon;
  final int index;
  _UnitView({this.icon, this.index});
  @override
  _UnitViewState createState() => _UnitViewState(icon, index);
}

class _UnitViewState extends State<_UnitView> {
  Icon icon;
  final int index;
  bool hide = true;
  _UnitViewState(this.icon, this.index);
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: hide,
      child: Container(
        width: 30,
        height: 30,
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
  final Icon target;
  _QuestAnswer(this.answer, this.ctxx, this.target);
  @override
  _QuestAnswerState createState() => _QuestAnswerState(answer, ctxx, target);
}

class _QuestAnswerState extends State<_QuestAnswer> {
  final int answer;
  final BuildContext ctxx;

  List childrens;
  final Icon target;
  _QuestAnswerState(this.answer, this.ctxx, this.target);

  int groupValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
          child: Column(children: <Widget>[
        SizedBox(height: 30),
        target,
        SizedBox(
          height: 10,
        ),
        Text('请选择上面图形的出现次数', style: TextStyle(fontSize: 20)),
        SizedBox(height: 30),
        Row(
          children: _getOptions(),
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
  List <Icon> datalist;
  FreshEvent(this.current,this.datalist);
}

class ResetNotify {
  ResetNotify();
}
