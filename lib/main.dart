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
const List menu = [['数字舒尔特表格训练','文字舒尔特表格训练'],
                   ['数字感知训练','中文感知训练','第一图形感知训练','多图形感知训练'],
                   ['矩形扩展训练','圆形扩展训练','数字扩展训练','文字扩展训练'],
                   ['圆形移动训练','之字形移动训练','N字形移动训练']];

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
      child: Container(
        child: Row(
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
              child: Container(
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 60, 50, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.blueAccent,
                          width:  MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 1.5,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey,
                  
                          ),
                        )
                      ],
                    ),
                  )),
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
      width: MediaQuery.of(context).size.width / 7,
      child: Column(
        children: <Widget>[
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width / 7,
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
                  children: getChildren()
                ),
              ))
        ],
      ),
    );
  }

  List <Widget> getChildren(){
    List temp = menu[widget.idx];
    return List.generate(temp.length , (index){
      return Padding(
        padding: EdgeInsets.all(5),
        child: FlatButton(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          child: Text('${temp[index]}',style: TextStyle(fontSize: 14),textAlign: TextAlign.center),
        ) // Text('${temp[index]}',style: TextStyle(fontSize: 14),textAlign: TextAlign.center)
      );
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

class SuperSelEvent {
  int curidx;
  SuperSelEvent(this.curidx);
}

class _ShareInherit extends InheritedWidget {
  _ShareInherit({Key key, this.child}) : super(key: key, child: child);

  final Widget child;

  int curIdx;

  static _ShareInherit of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_ShareInherit)
        as _ShareInherit);
  }

  @override
  bool updateShouldNotify(_ShareInherit oldWidget) {
    return true;
  }
}
