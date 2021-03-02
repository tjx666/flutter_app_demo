import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './lazy_indexed_stack.dart';

class AppState extends ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
  }
}

class TestProvider extends StatefulWidget {
  TestProvider({Key key}) : super(key: key);

  @override
  _TestProviderState createState() => _TestProviderState();
}

class _TestProviderState extends State<TestProvider> {
  int activeTabIndex = 0;

  Widget _tabView(int index) {
    final count = context.select<AppState, int>((state) => state.count);
    return Text('tab view $index, count: $count');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 '),
      ),
      body: ChangeNotifierProvider(
        create: (context) => AppState(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: LazyIndexedStack(
                reuse: false,
                index: activeTabIndex,
                itemCount: 2,
                itemBuilder: (context, index) => _tabView(index),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      activeTabIndex = 0;
                    });
                  },
                  child: Text('tab0'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      activeTabIndex = 1;
                    });
                  },
                  child: Text('tab1'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
