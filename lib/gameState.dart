import 'package:flutter/material.dart';

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

enum TileType{
  tillable, tilled, water, path, occupied, planted

}

class GameInfoState extends State<GameInfo>{

  int boardwidth;
  int boardheight;
  List<TileType> gameBoard;

  @override initState(){
    super.initState();
    initGameBoard();
  }
  setBoardwidth(int width){
    setState(() {
      this.boardwidth=width;
    });
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
    gameBoard = new List.generate(defaultWidth*defaultHeight, (_) => TileType.tillable);
    this.boardwidth=defaultWidth;
    this.boardheight=defaultHeight;
  }
  List<TileType> getGameBoard(){
    return gameBoard;
  }

  setTile(int index, TileType tile){
    setState(() {
      this.gameBoard[index]=tile;
    });
  }
  _setGameBoard(List<TileType> newGameBoard){
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
