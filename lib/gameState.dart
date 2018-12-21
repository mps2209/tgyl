import 'package:flutter/material.dart';
import 'plant.dart';
import 'dart:math';
import 'tile.dart';
import 'const.dart';
class GameInfoInherited extends InheritedWidget {
  GameInfoInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final GameInfoState data;

  @override
  bool updateShouldNotify(GameInfoInherited oldWidget) {
    return true;
  }
}


class GameInfo extends StatefulWidget {
  GameInfo({
    Key key,
    this.child,
  }): super(key: key);

  final Widget child;

  @override
  GameInfoState createState() => new GameInfoState();

  static GameInfoState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(GameInfoInherited) as GameInfoInherited).data;
  }
}



class GameInfoState extends State<GameInfo>{

  int gold;
  int boardwidth;
  int boardheight;
  List<Tile> gameBoard;
  bool showTools =false;
  @override initState(){
    super.initState();
    gold=10;
    initGameBoard();
  }
  setBoardwidth(int width){
    setState(() {
      this.boardwidth=width;
    });
  }


  switchShowTools(){
    setState(() {
      showTools=!showTools;
    });
  }
  bool addToGold(int earning){

    if (gold+earning >= 0) {
      setState(() {
        gold += earning;
      });
      return true;
    }
    return false;
  }

  bool substractFromGold(int cost){
    if (gold<cost){
      return false;
    }
    setState(() {
      gold-=cost;
    });
    return true;
  }


  setBoardheight(int height){
    setState(() {
      this.boardheight=height;
    });
  }

  int getBoardWidth(){
    return boardwidth;
  }
  int getBoardHeigth(){
    return boardheight;
  }
  void initGameBoard(){
    int defaultWidth= 5;
    int defaultHeight=7;
    defaultHeight??=boardheight;
    defaultWidth??=boardwidth;
    gameBoard = new List.generate(defaultWidth*defaultHeight, (index) => Tile(TileType.tillable,index));
    this.boardwidth=defaultWidth;
    this.boardheight=defaultHeight;
  }

  List<Tile> getGameBoard(){
    return gameBoard;
  }

  setTile(int index, Tile tile){
    setState(() {
      this.gameBoard[index]=tile;
    });
  }
  _setGameBoard(List<Tile> newGameBoard){
    setState(() {
      this.gameBoard = newGameBoard;
    });
  }
  /// List of Items

  /// Getter (number of items)


  /// Helper method to add an Item

  @override
  Widget build(BuildContext context){
    return new GameInfoInherited(
      data: this,
      child: widget.child,
    );
  }
}



