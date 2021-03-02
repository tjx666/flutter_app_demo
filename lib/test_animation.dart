import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'main.dart';

class TestAnimation extends StatefulWidget {
  TestAnimation({Key key}) : super(key: key);

  @override
  _TestAnimationState createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  ItemScrollController itemScrollController = ItemScrollController();
  String desc = 'open panel';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                desc = 'open panel';
              });
            } else if (status == AnimationStatus.completed) {
              setState(() {
                desc = 'close panel';
              });
            } else {
              setState(() {
                desc = 'animating';
              });
            }
          });
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  void animate() {
    if (animation.status == AnimationStatus.dismissed) {
      animationController.forward();
    } else if (animation.status == AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const appBarHeight = 100.0;
    const panelHeight = 292.0;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black,
        child: Stack(
          children: [
            Positioned(
              width: screenWidth,
              height: appBarHeight,
              top: -(1 - animation.value) * appBarHeight,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Text('app bar'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 120,
                height: 50,
                child: RaisedButton(
                  child: Text(desc),
                  onPressed: animate,
                ),
              ),
            ),
            Positioned(
              width: screenWidth,
              height: panelHeight,
              bottom: -(1 - animation.value) * panelHeight,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    width: screenWidth,
                    height: 80,
                    child: ScrollablePositionedList.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemPositionsListener: ItemPositionsListener.create(),
                      itemScrollController: itemScrollController,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: index == 0 ? null : EdgeInsets.only(left: 10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              itemScrollController.scrollTo(
                                index: index,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: Image.asset(
                              'images/wallpaper_${index % 2}.jpg',
                              width: 80,
                              height: 80,
                              repeat: ImageRepeat.noRepeat,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
