import 'package:flutter/material.dart';
import './color_picker.dart';

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  Color currentColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              color: currentColor,
              margin: EdgeInsets.only(top: 10, bottom: 20),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: (value) {
                  setState(() {
                    currentColor = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
