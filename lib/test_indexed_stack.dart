import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  int index;
  TabView({Key key, this.index}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  void initState() {
    super.initState();
    print('init tabView ${widget.index}');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose tabView ${widget.index}');
  }

  @override
  Widget build(BuildContext context) {
    print('build tabView ${widget.index}');

    return Container(
      width: 200,
      height: 200,
      child: Center(
        child: Text('view ${widget.index}'),
      ),
    );
  }
}

class TestIndexedStack extends StatefulWidget {
  TestIndexedStack({Key key}) : super(key: key);

  @override
  _TestIndexedStackState createState() => _TestIndexedStackState();
}

class _TestIndexedStackState extends State<TestIndexedStack> {
  int viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 IndexedStack'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IndexedStack(
            index: viewIndex,
            children: List<Widget>.generate(
              3,
              (index) => TabView(index: index),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              3,
              (index) => FlatButton(
                onPressed: () {
                  setState(() {
                    viewIndex = index;
                  });
                },
                child: Text('$index'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
