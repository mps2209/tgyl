import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:math';
import 'gameState.dart';
import 'const.dart';
import 'tile.dart';

class Plant extends StatefulWidget {
  int tileIndex;
  Plant(int this.tileIndex);
  @override
  State<StatefulWidget> createState() => PlantState(tileIndex);
}

class PlantState extends State<Plant> with TickerProviderStateMixin {
  AnimationController controller;
  bool readyToHarvest=false;
  int timeToGrow=10;
  int timeLeft=10;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: timeToGrow),
    );
    controller.addStatusListener((state)=> growthListener(state));
    controller.forward(from: 0.0);
  }

  void growthListener(AnimationStatus status){
    if (status==AnimationStatus.completed){
      setState(() {
        readyToHarvest=true;
        print("ready to harvest");
      });
      final GameInfoState state= GameInfo.of(context);
      Tile grownTile= state.getGameBoard()[_tileIndex];
      grownTile.harvestable=true;
      state.setTile(_tileIndex, grownTile);
    }
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int _tileIndex;
  PlantState(int this._tileIndex);
  String _currentAnim = "left";
  bool _isAnimating;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        new FlareActor("assets/plantforthandback.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: _currentAnim, callback: (string) {
              _isAnimating = false;
              debugPrint(string);
              String nextAnim;
              var rnd = new Random();
              if (rnd.nextBool()) {
                print(timerString);
//        print("next left");
                if (string == "left") {
                  setState(() {
                    _currentAnim = "leftlast";
                  });
                } else {
                  setState(() {
                    _currentAnim = "left";
                  });
                }
              } else {
//        print("next right");

                if (string == "right") {
                  setState(() {
                    _currentAnim = "rightlast";
                  });
                } else {
                  setState(() {
                    _currentAnim = "right";
                  });
                }
              }
            }),
        _getCountdown(),
      ],
    );
  }

  _getCountdown(){
    Widget widget;
    readyToHarvest ? widget= Container():
    widget= new Countdown(
      countingDownFrom: timeToGrow,
      animation: new CurvedAnimation(parent: controller, curve: Curves.linear),
    );
    return widget;
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation, this.countingDownFrom}) : super(key: key, listenable: animation);
  CurvedAnimation animation;
  int countingDownFrom;
  @override
  build(BuildContext context) {
    return Center(
      child: new CircularProgressIndicator(
        value: animation.value,
      ),
    );
  }
}
