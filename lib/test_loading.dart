import 'package:flutter/material.dart';

class TestLoading extends StatefulWidget {
  TestLoading({Key key}) : super(key: key);

  @override
  _TestLoadingState createState() => _TestLoadingState();
}

class _TestLoadingState extends State<TestLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 loading'),
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: CircularProgressIndicator(
            
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
