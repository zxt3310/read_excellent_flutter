import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_excellent/Tools/UIDefine.dart';
import 'game/FocusTrain.dart';
import 'game/perception.dart';
import 'game/visionTrain.dart';
import 'game/vistaExtent.dart';

EventBus eventBus = EventBus();
const List menu = [
  ['数字舒尔特表格训练', '文字舒尔特表格训练'],
  ['数字感知训练', '中文感知训练', '第一图形感知训练', '多图形感知训练'],
  ['矩形扩展训练', '圆形扩展训练', '数字扩展训练', '文字扩展训练'],
  ['圆形移动训练', '之字形移动训练', 'N字形移动训练']
];

void main() {
  // 强制横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(),
      home: HomeView(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.red),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text('让孩子爱上阅读\n成为学霸',
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                child: Text('速度训练'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VistaTrain(shape: RectShape.shapeRoundRect)));
                },
              ),
              MaterialButton(
                child: Text('限时阅读'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Vision(path: GamePath.pathN)));
                },
              ),
              MaterialButton(
                child: Text('速度测评'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PerceptionTrain(
                              mode: GameMode.modeNormal,
                              content: GameCtx.ctxNum)));
                },
              ),
              MaterialButton(
                child: Text('潜能训练'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FocusTrain.number(6)));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ShareInherit(
      child: Scaffold(
        body: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4,
              color: Colors.yellowAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TrainSuperButton(
                    idx: 0,
                    title: '专注力训练',
                  ),
                  TrainSuperButton(
                    idx: 1,
                    title: '视觉感知训练',
                  ),
                  TrainSuperButton(
                    idx: 2,
                    title: '视幅拓展训练',
                  ),
                  TrainSuperButton(
                    idx: 3,
                    title: '视点移动训练',
                  )
                ],
              ),
            ),
            Expanded(
              // child: Container(
              //     color: Colors.blueGrey,
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(50, 60, 50, 30),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.stretch,
              //         children: <Widget>[
              //           Container(
              //             color: Colors.blueAccent,
              //             width: MediaQuery.of(context).size.width / 3,
              //             height: MediaQuery.of(context).size.height / 1.5,
              //           ),
              //           Expanded(
              //             child: Container(
              //               color: Colors.grey,
              //             ),
              //           )
              //         ],
              //       ),
              //     )),
              child: GameDetailView(),
            )
          ],
        ),
      ),
    );
  }
}

class TrainSuperButton extends StatefulWidget {
  final int idx;
  final String title;
  final List children;
  TrainSuperButton({this.idx, this.title, this.children});
  @override
  _TrainSuperButtonState createState() => _TrainSuperButtonState();
}

class _TrainSuperButtonState extends State<TrainSuperButton> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 6.5,
      child: Column(
        children: <Widget>[
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 6.5,
            padding: EdgeInsets.all(12),
            color: Colors.deepOrange,
            child: Text('${widget.title}',
                style: TextStyle(
                    fontSize: 16, color: hide ? Colors.black : Colors.white)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: _btnPress,
          ),
          Container(
              color: Colors.white,
              child: Offstage(
                offstage: hide,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //children: getChildren(),
                    children: getChildren()),
              ))
        ],
      ),
    );
  }

  List<Widget> getChildren() {
    List temp = menu[widget.idx];
    return List.generate(temp.length, (index) {
      return Padding(
          padding: EdgeInsets.all(0),
          // child: FlatButton(
          //   child: Text('${temp[index]}',
          //       style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
          //   onPressed: () {},
          // )
          child: ChildGameSel(superIdx: widget.idx, childIdx: index));
    });
  }

  void _btnPress() {
    eventBus.fire(SuperSelEvent(widget.idx));
  }

  StreamSubscription subscription;
  @override
  void initState() {
    subscription = eventBus.on<SuperSelEvent>().listen((event) {
      hide = widget.idx == event.curidx ? false : true;
      this.setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class ChildGameSel extends StatefulWidget {
  final int superIdx;
  final int childIdx;
  ChildGameSel({this.superIdx, this.childIdx});
  @override
  _ChildGameSelState createState() => _ChildGameSelState();
}

class _ChildGameSelState extends State<ChildGameSel> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    List temp = menu[widget.superIdx];
    return FlatButton(
      child: Text('${temp[widget.childIdx]}',
          style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
      textColor: pressed ? Colors.red : Colors.black,
      onPressed: () {
        eventBus.fire(
            ChildSelEvent(childIdx: widget.childIdx, subIdx: widget.superIdx));
        _ShareInherit.of(context).superIdx = widget.superIdx;
        _ShareInherit.of(context).childIdx = widget.childIdx;
      },
    ); // Text('${temp[
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<ChildSelEvent>().listen((event) {
      pressed =
          (event.subIdx == widget.superIdx && event.childIdx == widget.childIdx)
              ? true
              : false;
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

class GameDetailView extends StatefulWidget {
  @override
  _GameDetailViewState createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  int superIdx = -1;
  int childIdx = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 60, 50, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    color: Colors.blueAccent,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Center(
                      child: Container(
                          child: Text(_scribe(),
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  decoration: TextDecoration.none))),
                    )),
                Expanded(
                  child: Container(
                    color: Colors.deepPurpleAccent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: superIdx > 0 ? ModeOption() : FocusOption(),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  MaterialButton(
                                    color: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    minWidth: 150,
                                    height: 49,
                                    child: Text('start',
                                        style: TextStyle(fontSize: 18)),
                                    onPressed: () {},
                                  )
                                ])))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  String _scribe() {
    return childIdx == -1 ? '欢迎来到训练场' : '${menu[superIdx][childIdx]}';
  }

  void startGame() {
    int supIdx = _ShareInherit.of(context).superIdx;
    int chilIdx = _ShareInherit.of(context).childIdx;
    GameMode mode = _ShareInherit.of(context).mode;
    int size = _ShareInherit.of(context).gameSize;

    GameAssistant helper = GameAssistant(
        childIdx: chilIdx, superIdx: supIdx, mode: mode, gameSize: size);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => helper.getTargetGame()));
  }

  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<ChildSelEvent>().listen((event) {
      superIdx = event.subIdx;
      childIdx = event.childIdx;
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

//游戏速度选项
class ModeOption extends StatefulWidget {
  @override
  _ModeOptionState createState() => _ModeOptionState();
}

class _ModeOptionState extends State<ModeOption> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: RadioListTile(
                title: Text('快',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                value: 0,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
          Flexible(
            child: RadioListTile(
                title: Text('中',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                value: 1,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
          Flexible(
            child: RadioListTile(
                title: Text('慢',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                value: 2,
                groupValue: groupValue,
                onChanged: (value) {
                  changed(value);
                }),
          ),
        ],
      ),
    );
  }

  void changed(value) {
    groupValue = value;
    this.setState(() {});
    _ShareInherit.of(context).mode = GameMode.values[value];
  }
}

//专注力训练选项
class FocusOption extends StatefulWidget {
  @override
  _FocusOptionState createState() => _FocusOptionState();
}

class _FocusOptionState extends State<FocusOption> {
  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                    title: Text('3x3',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 0,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('4x4',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('5x5',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                    title: Text('6x6',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 3,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('7x7',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 4,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text('8x8',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    value: 5,
                    groupValue: groupValue,
                    onChanged: (value) {
                      changed(value);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  void changed(value) {
    groupValue = value;
    this.setState(() {});
    _ShareInherit.of(context).gameSize = value + 3;
  }
}

// 事件类型定义
// 游戏类型选择 点击事件
class SuperSelEvent {
  @required
  int curidx;
  SuperSelEvent(this.curidx);
}

// 游戏分支选择 点击事件
class ChildSelEvent {
  @required
  int subIdx;
  @required
  int childIdx;
  ChildSelEvent({this.subIdx, this.childIdx});
}

class ModeRadioEvent {
  @required
  int curValue;
  ModeRadioEvent(this.curValue);
}

class _ShareInherit extends InheritedWidget {
  _ShareInherit({Key key, this.child}) : super(key: key, child: child);

  final Widget child;

  int superIdx;
  int childIdx;

  GameMode mode = GameMode.modeFast;
  int gameSize = 3;

  static _ShareInherit of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_ShareInherit)
        as _ShareInherit);
  }

  @override
  bool updateShouldNotify(_ShareInherit oldWidget) {
    return true;
  }
}

//辅助工具类 筛选游戏

class GameAssistant {
  @required
  final int superIdx;

  @required
  final int childIdx;

  final int gameSize;
  final GameMode mode;

  GameAssistant({this.superIdx, this.childIdx, this.gameSize, this.mode});

  Widget getTargetGame() {
    Widget wid;
    switch (superIdx) {
      case 0:
        wid = FocusTrain.number(gameSize);
        break;
      case 1:
        wid = PerceptionTrain(mode: mode,content: GameCtx.ctxNum);
        break;
      case 2:
        wid = Vision(path: GamePath.pathN);
        break;
      case 3:
        wid = VistaTrain(shape: RectShape.shapeRoundRect);
        break;
      default:
    }

    return wid;
  }
}
