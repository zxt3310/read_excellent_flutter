import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/FocusTrain.dart';

void main() {
  // 强制横屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
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
      home: MyHomePage(),
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
              border: Border.all(width: 2,color: Colors.red),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text('让孩子爱上阅读\n成为学霸',style: TextStyle(fontSize: 20),textAlign: TextAlign.center),
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
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
                onPressed: (){},
              ),
             
              MaterialButton(
                child: Text('限时阅读'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
                onPressed: (){},
              ),
              MaterialButton(
                child: Text('速度测评'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
                onPressed: (){},
              ),
              MaterialButton(
                child: Text('潜能训练'),
                color: Colors.yellow[300],
                height: 40,
                minWidth: 120,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10))),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FocusTrain.number(6)));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
