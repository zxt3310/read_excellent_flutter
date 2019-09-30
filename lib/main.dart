import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Tools/UIDefine.dart';
import 'game/FocusTrain.dart';
import 'game/perception.dart';
import 'game/visionTrain.dart';
import 'game/vistaExtent.dart';


EventBus eventBus = EventBus();
const List menu = [
  ['数字舒尔特表格训练', '文字舒尔特表格训练'],
  ['数字感知训练', '中文感知训练', '第一图形感知训练', '多图形感知训练'],
  ['矩形扩展训练', '圆形扩展训练' /*, '数字扩展训练', '文字扩展训练'*/],
  ['N字形移动训练', '之字形移动训练' /*, '圆形移动训练'*/]
];

void main() {

  WidgetsFlutterBinding.ensureInitialized();
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
    return _ShareInherit(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        unselectedWidgetColor: Colors.white,
      ),
      home: HomeView(),
    ));
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF448D60),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('images/bg.png'), fit: BoxFit.fill)),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF99A2F),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.zero, right: Radius.circular(60))),
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TrainSuperButton(
                      idx: 0,
                      title: '专注力训练',
                    ),
                    SizedBox(height: 20),
                    TrainSuperButton(
                      idx: 1,
                      title: '视觉感知训练',
                    ),
                    SizedBox(height: 20),
                    TrainSuperButton(
                      idx: 2,
                      title: '视幅拓展训练',
                    ),
                    SizedBox(height: 20),
                    TrainSuperButton(
                      idx: 3,
                      title: '视点移动训练',
                    )
                  ],
                ),
              ),
              Expanded(
                child: GameDetailView(),
              )
            ],
          )),
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
      width: MediaQuery.of(context).size.width / 5.5,
      child: Column(
        children: <Widget>[
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 5.5,
            padding: EdgeInsets.all(20),
            child: Text('${widget.title}',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PingFangSC-Medium',
                    color: hide ? Colors.white : Color(0xFFF99A2F))),
            color: hide ? Color(0xFFF99A2F) : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(width: 6, color: Color(0xFFFFC85F))),
            onPressed: _btnPress,
          ),
          SizedBox(height: 2),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFE8DFD6)),
              child: Offstage(
                offstage: hide,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
          style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
      textColor: pressed ? Color(0xFFFF7720) : Colors.black,
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
  static const platform = const MethodChannel('Read_excellent');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
              FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('images/icon_back.png'),
                    SizedBox(width: 10),
                    Text('返回',
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.none)),
                  ],
                ),
                onPressed: () {
                  //Navigator.of(context).pop();
                  platform.invokeMethod('popRoute');
                },
              )
            ]),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFE8DFD6),
                    border: Border.all(width: 12, color: Color(0xFFFF7720))),
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 1.6,
                child: Center(
                  child: Container(
                      child: Text(_scribe(),
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              decoration: TextDecoration.none))),
                )),
            SizedBox(height: 20),
            Expanded(
              child: Container(
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
                              FlatButton(
                                child: Container(
                                    width: 162,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: const AssetImage(
                                                'images/an_bg_n.png'),
                                            fit: BoxFit.fill)),
                                    child: Center(
                                        child: Text('开始',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white)))),
                                onPressed: _startGame,
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

  void _startGame() {
    int supIdx = _ShareInherit.of(context).superIdx;
    int chilIdx = _ShareInherit.of(context).childIdx;
    GameMode mode = _ShareInherit.of(context).mode;
    int size = _ShareInherit.of(context).gameSize;

    GameAssistant helper = GameAssistant(
        childIdx: chilIdx, superIdx: supIdx, mode: mode, gameSize: size);

    print(helper.getTargetGame());
    Navigator.of(context).push(MaterialPageRoute(
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
                activeColor: const Color(0xFFFF7720),
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
                activeColor: const Color(0xFFFF7720),
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
                activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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
                    activeColor: const Color(0xFFFF7720),
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

  int superIdx = 0;
  int childIdx = 0;

  GameMode mode = GameMode.modeFast;
  int gameSize = 3;

  static _ShareInherit of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_ShareInherit)
        as _ShareInherit);
  }

  @override
  bool updateShouldNotify(_ShareInherit oldWidget) {
    return false;
  }
}

//辅助工类 筛选���戏

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
        if (childIdx == 0) {
          wid = FocusTrain.number(size: gameSize, ctx: GameCtx.ctxNum);
        } else {
          wid = FocusTrain.number(size: gameSize, ctx: GameCtx.ctxStr);
        }
        break;
      case 1:
        switch (childIdx) {
          case 0:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxNum);
            break;
          case 1:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxStr);
            break;
          case 2:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxGraphicUnion);
            break;
          case 3:
            wid = PerceptionTrain(mode: mode, content: GameCtx.ctxGraphic);
        }
        break;
      case 2:
        switch (childIdx) {
          case 0:
            wid = VistaTrain(
              shape: RectShape.shapeRoundRect,
              mode: mode,
            );
            break;
          case 1:
            wid = VistaTrain(shape: RectShape.shapeCycle, mode: mode);
            break;
          default:
            wid = VistaTrain(shape: RectShape.shapeRoundRect,mode: mode,);
            break;
        }
        break;
      case 3:
        switch (childIdx) {
          case 0:
            wid = Vision(path: GamePath.pathN,mode: mode);
            break;
          case 1:
            wid = Vision(path: GamePath.pathZ,mode:mode);
            break;
          default:
        }

        break;
      default:
    }

    return wid;
  }
}
