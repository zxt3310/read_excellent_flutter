/// 专注训练
///

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';


class FocusTrain extends StatefulWidget {
  final int size;
  final List<String> strs;

  FocusTrain(this.size, this.strs);
  FocusTrain.number(int x) : this(x, null);
  FocusTrain.strAry(List<String> ary) : this(null, ary);
  @override
  FocusTrainState createState() => FocusTrainState(size, strs);
}

class FocusTrainState extends State<FocusTrain> {
  int size;
  List<String> strs;
  List<UnitContainer> _datasource;

  FocusTrainState(this.size, this.strs) {
    _datasource = _buildContextList();
  }
  @override
  Widget build(BuildContext context) {
    // if (size > 0) {
    return Scaffold(
        body: _UnitContainerInher(
            source: _getIntPool(),
            counted: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.height*0.7,
                  height:MediaQuery.of(context).size.height*0.7 + 25,
                  child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      crossAxisCount: size,
                      children: _datasource),
                ),
                Padding(padding: EdgeInsets.all(10)),
                CountDownTimer(90)
              ],
            )));
    //}
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
      return UnitContainer(ran);
    });
    return containers;
  }
}

class UnitContainer extends StatefulWidget {
  final int random;
  UnitContainer(this.random) : super();
  @override
  _UnitContainerState createState() => _UnitContainerState(random);
}

class _UnitContainerState extends State<UnitContainer> {
  int ran;
  bool visable = true;

  _UnitContainerState(this.ran) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
          child: FlatButton(
        padding: EdgeInsets.all(5),
        child: Text(visable ? ran.toString() : '',
            style: TextStyle(fontSize: 15, color: Colors.red)),
        onPressed: _punchUnit,
      )),
    );
  }

  void _punchUnit() {
    _UnitContainerInher inherContainer = _UnitContainerInher.of(context);
    List<int> pool = inherContainer.source;
    int conted = inherContainer.counted;
    Timer timer = inherContainer.timer;
    if (pool.first == ran) {
      visable = false;
      pool.remove(ran);
      this.setState(() {});
    }
    if (pool.isEmpty) {
      timer.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx){return Sucessed(over: true,score: conted, superCtx: context);}
      );
    }
  }
}

class _UnitContainerInher extends InheritedWidget {
  static _UnitContainerInher of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_UnitContainerInher);
  List<int> source;
  int counted;
  Timer timer;

  _UnitContainerInher({Key key, this.source,this.counted, @required Widget child})
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
  int _count = 5;

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
              // Navigator.of(context).pop();
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext ctx){
                  print(ctx.widget);
                  return Sucessed(
                    over: false,
                    superCtx: context,
                  );
                }
              );
            } else {
              _count -= 1;
              inherContainer.counted +=1;
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
  Sucessed({this.over, this.score,this.superCtx});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(over?'用时：${score.toString()}秒\n太棒了！':'胜败乃兵家常事，再接再厉',style: TextStyle(fontSize: 18,decoration: TextDecoration.none,backgroundColor: Colors.white)),
            Padding(padding: EdgeInsets.all(10)),
            MaterialButton(
              child: Text('返回上层'),
              color: Colors.blueAccent,
              onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(superCtx).pop();
                },
            )
          ],
        ),
      )
    );
  }
}