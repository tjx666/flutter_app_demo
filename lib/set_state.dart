import 'package:flutter/material.dart';

class TestSetState extends StatefulWidget {
  TestSetState({Key key}) : super(key: key);

  @override
  _TestSetStateState createState() => _TestSetStateState();
}

class CompA extends StatefulWidget {
  CompA({Key key}) : super(key: key) {
    print('run compA constructor');
  }

  @override
  _CompAState createState() => _CompAState();
}

class _CompAState extends State<CompA> {
  @override
  
  
  @override
  Widget build(BuildContext context) {
    print('build a');
    return Container(
      child: Center(
        child: RaisedButton(
          color: Colors.red,
          child: Text('compA'),
          onPressed: () {
            print('setState a');
            setState(() {});
          },
        ),
      ),
    );
  }
}

class CompB extends StatefulWidget {
  CompB({Key key}) : super(key: key) {
    print('run compB constructor');
  }

  @override
  _CompBState createState() => _CompBState();
}

class _CompBState extends State<CompB> {
  @override
  Widget build(BuildContext context) {
    print('build b');
    return Container(
      child: Center(
        child: RaisedButton(
          color: Colors.blue,
          child: Text('compB'),
          onPressed: () {
            print('setState b');
            setState(() {});
          },
        ),
      ),
    );
  }
}

class CompC extends StatelessWidget {
  CompC({Key key}) : super(key: key) {
    print('run compC constructor');
  }

  @override
  Widget build(BuildContext context) {
    print('build c');
    return Container(
      child: Center(
        child: RaisedButton(
          color: Colors.blue,
          child: Text('compC'),
          onPressed: () {},
        ),
      ),
    );
  }
}

class _TestSetStateState extends State<TestSetState> {
  @override
  Widget build(BuildContext context) {
    print('build root');
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 canvas'),
      ),
      body: Column(
        children: [
          CompA(),
          CompB(),
          CompC(),
          RaisedButton(
            color: Colors.green,
            child: Text('root'),
            onPressed: () {
              print('setState root');
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
