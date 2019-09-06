import 'dart:async';

import 'package:flutter/material.dart';
import 'package:read_excellent/Tools/UIDefine.dart';
import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class Vision extends StatefulWidget {
  final GamePath path;
  final GameMode mode;
  Vision({this.path, this.mode});
  @override
  _VisionState createState() => _VisionState(path,mode);
}

class _VisionState extends State<Vision> {
  final GamePath path;
  final GameMode mode;
  int cout = 7;
  Timer _timer;
  _VisionState(this.path,this.mode);
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
    if (path != GamePath.pathX) {
      return List<Widget>.generate(8, (int idx) {
        double x = -0.75 + idx ~/ 2 * 0.5;
        double y = (idx % 2 == 0) ? -0.75 : 0.75;
        return Align(
            child: _UnitView(icon: Icon(Icons.add_alarm), index: idx),
            alignment: Alignment(x, y));
      });
    }
    return null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startGame();
  }

  void _startGame(){
    var callBack = (Timer timer){
      if(cout < 0){
        timer.cancel();
      }else{
        eventBus.fire(FreshEvent(7-cout));
        cout -= 1;
      }
    };

    var oneSec = Duration(seconds: 1);
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
  final Icon icon;
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
        hide = event.current == index?false:true;
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

//通知
class FreshEvent {
  int current;
  FreshEvent(this.current);
}