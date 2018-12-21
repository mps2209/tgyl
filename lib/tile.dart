import 'package:flutter/material.dart';
import 'plant.dart';
import 'dart:math';
import 'const.dart';




class Tile{

  int bonus=0;
  double chanceToLvlUp=0.5;
  int tileLevel=1;
  int _gold=10;
  int cost=-5;
  int index;
  TileType type;
  Plant plant;
  bool harvestable=false;
  bool didJustHarvest=false;
  Tile(this.type,this.index);

  checkLvlUp(){
    didJustHarvest=true;
    var chance= new Random();
    double d = chance.nextDouble();
    print(d.toString());
    if (d > chanceToLvlUp){
      tileLevel++;
      chanceToLvlUp=chanceToLvlUp/2;
      cost= (cost*1.2).ceil();
      _gold=(_gold*1.5).ceil();
    }
  }
  int getGold(){
    return (_gold+_gold*(bonus/100)).ceil();
  }




  Container getTileContainer() {
    switch (type) {
      case TileType.water:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            border: new Border.all(color: Colors.blueAccent),
          ),
        );
        break;
      case TileType.occupied:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: new Border.all(color: Colors.redAccent),
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
            Center(child:Cost(cost*2)),
            ],
        ),);
        break;
      case TileType.path:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: new Border.all(color: Colors.blueGrey),
          ),
        );
        break;
      case TileType.tilled:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.brown,
            border: new Border.all(color: Colors.black),
          ),
        );
        break;
      case TileType.tillable:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: new Border.all(color: Colors.greenAccent),

          ),
          child: didJustHarvest? _getCostAnimation() : null,
        );
        break;
      case TileType.planted:
        return new Container(
          decoration: BoxDecoration(
            color: Colors.brown,
            border: new Border.all(color: Colors.black),
          ),
          child: Stack(children: <Widget>[
            new Plant(index),
            Center(child: Cost(cost),
            ),
          ]),
        );
        break;
    }
    return null;
  }
  _getCostAnimation(){
    didJustHarvest=false;
    return Center(child: new Cost(getGold()));
  }
}


class Cost extends StatefulWidget{
  int cost;
  Cost(this.cost);
  @override
  State<StatefulWidget> createState()=> CostState(cost);
}
class CostState extends State<Cost> with TickerProviderStateMixin {
  int cost;
  Animation<double> animation;
  AnimationController controller;

  static const int duration= 2000;
  double maxValue=50;
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: duration), vsync: this);
    animation = Tween(begin: 0.0, end: maxValue).animate( CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0, 1.000,
        curve: Curves.easeOut,
      ),),)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  CostState(this.cost);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(bottom: animation.value),
        child: Opacity(
            opacity: 1-animation.value/maxValue,
            child: new Text(cost.toString(), style: TextStyle(fontSize: 25, color:
            cost<0?Colors.redAccent: Colors.yellow,),)));

  }

}