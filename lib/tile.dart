import 'package:flutter/material.dart';
import 'plant.dart';
import 'dart:math';
import 'const.dart';
import 'gameState.dart';

class Tile extends StatelessWidget {
  List<bool> bonusesfromDirectionNOSW = [false, false, false, false];
  int bonusreceived = 0;
  int bonusgiven = 0;
  double chanceToLvlUp = 0.5;
  int tileLevel = 1;
  int _gold = 10;
  int cost = -5;
  int index;
  TileType type;
  Plant plant;
  bool harvestable = false;
  bool didJustHarvest = false;
  Tile(this.type, this.index);

  checkLvlUp() {
    didJustHarvest = true;
    var chance = new Random();
    double d = chance.nextDouble();
    print(d.toString());
    if (d > chanceToLvlUp) {
      tileLevel++;
      chanceToLvlUp = chanceToLvlUp / 2;
      cost = (cost * 1.2).ceil();
      _gold = (_gold * 1.5).ceil();
    }
  }

  int getGold() {
    return (_gold + _gold * (bonusreceived / 100)).ceil();
  }

  Container getTileContainer() {
    switch (type) {
      case TileType.water:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.greenAccent),
          ),
          child: Center(child: new Cost(-5,0)),
        );
        break;
      case TileType.occupied:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.greenAccent),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/Dwarfwhite.png'),
                )),
              ),
              Center(child: Cost(cost * 2,bonusreceived)),
            ],
          ),
        );
        break;
      case TileType.path:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.greenAccent),
          ),
          child: Center(
            child: Cost(-5,0),
          ),
        );
        break;
      case TileType.tilled:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.brown,
            border: _getBorder(),
          ),
        );
        break;
      case TileType.tillable:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.greenAccent),
          ),
          child: didJustHarvest ? _getCostAnimation() : null,
        );
        break;
      case TileType.planted:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.brown,
            border: _getBorder(),
          ),
          child: Stack(children: <Widget>[
            new Plant(index),
            Center(
              child: Cost(cost,bonusreceived),
            ),
          ]),
        );
        break;
    }
    return null;
  }

  _getCostAnimation() {
    didJustHarvest = false;
    return Center(child: new Cost(getGold(),bonusreceived));
  }

  Border _getBorder() {
    return new Border(
      top: BorderSide(
          color: bonusesfromDirectionNOSW[HimmelsRichtung.Norden.index]
              ? Colors.redAccent
              : Colors.greenAccent,
          width: bonusesfromDirectionNOSW[HimmelsRichtung.Norden.index]
              ? 5.0
              : 1.0),
      bottom: BorderSide(
          color: bonusesfromDirectionNOSW[HimmelsRichtung.Sueden.index]
              ? Colors.redAccent
              : Colors.greenAccent,
          width: bonusesfromDirectionNOSW[HimmelsRichtung.Sueden.index]
              ? 5.0
              : 1.0),
      left: BorderSide(
          color: bonusesfromDirectionNOSW[HimmelsRichtung.Westen.index]
              ? Colors.redAccent
              : Colors.greenAccent,
          width: bonusesfromDirectionNOSW[HimmelsRichtung.Westen.index]
              ? 5.0
              : 1.0),
      right: BorderSide(
          color: bonusesfromDirectionNOSW[HimmelsRichtung.Osten.index]
              ? Colors.redAccent
              : Colors.greenAccent,
          width: bonusesfromDirectionNOSW[HimmelsRichtung.Osten.index]
              ? 5.0
              : 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getTileContainer();
  }
}

class Cost extends StatefulWidget {
  int cost;
  int bonus;
  Cost(this.cost,this.bonus);
  @override
  State<StatefulWidget> createState() => CostState(cost,bonus);
}

class CostState extends State<Cost> with TickerProviderStateMixin {
  int cost;
  int bonus;
  Animation<double> animation;
  AnimationController controller;

  static const int duration = 2000;
  double maxValue = 50;
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: 0.0, end: maxValue).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.000,
          curve: Curves.easeOut,
        ),
      ),
    )..addListener(() {
      setState(() {
        // the state that has changed here is the animation object’s value
      });
    });
    controller.forward();
  }

  CostState(this.cost,this.bonus);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        Container(
            margin: EdgeInsets.only(bottom: animation.value),
            child: Opacity(
                opacity: 1 - animation.value / maxValue,
                child: _getText(),
                ),

    );
  }
  _getText(){
    if(cost>0){
    return Text(
    '$cost\n'
      '(+$bonus %)',
    style: TextStyle(
      fontSize: 20,
      color: cost < 0 ? Colors.redAccent : Colors.yellow,
    ),);
  }else {
      return Text('$cost\n',
        style: TextStyle(
        fontSize: 25,
        color: cost < 0 ? Colors.redAccent : Colors.yellow,),
    );
  }
  }
}
