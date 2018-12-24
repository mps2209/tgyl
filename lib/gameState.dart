import 'package:flutter/material.dart';
import 'plant.dart';
import 'dart:math';
import 'tile.dart';
import 'const.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  }) : super(key: key);

  final Widget child;

  @override
  GameInfoState createState() => new GameInfoState();

  static GameInfoState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameInfoInherited)
            as GameInfoInherited)
        .data;
  }
}

class GameInfoState extends State<GameInfo> {

  int gold;
  int boardwidth;
  int boardheight;
  List<Tile> gameBoard;
  bool showTools = false;
  bool doneTutorial=false;
  @override
  initState() {
    super.initState();
    gold = 10;
    initGameBoard();
  }


  setTutorial(bool isdone){
    setState(() {
      doneTutorial=isdone;
    });
  }
  setBoardwidth(int width) {
    setState(() {
      this.boardwidth = width;
    });
  }

  switchShowTools() {
    setState(() {
      showTools = !showTools;
    });
  }

  bool addToGold(int earning) {
    if (gold + earning >= 0) {
      setState(() {
        gold += earning;
      });
      return true;
    }
    return false;
  }

  bool substractFromGold(int cost) {
    if (gold < cost) {
      return false;
    }
    setState(() {
      gold -= cost;
    });
    return true;
  }

  setBoardheight(int height) {
    setState(() {
      this.boardheight = height;
    });
  }

  int getBoardWidth() {
    return boardwidth;
  }

  int getBoardHeigth() {
    return boardheight;
  }

  void initGameBoard() {
    int defaultWidth = 5;
    int defaultHeight = 7;
    defaultHeight ??= boardheight;
    defaultWidth ??= boardwidth;
    gameBoard = new List.generate(defaultWidth * defaultHeight,
        (index) => Tile(TileType.tillable, index));
    this.boardwidth = defaultWidth;
    this.boardheight = defaultHeight;
  }

  List<Tile> getGameBoard() {
    return gameBoard;
  }

  setTile(int index, Tile tile) {
    setState(() {
      this.gameBoard[index] = tile;
    });
    updateNeighbours(tile);
  }



  updateNeighbours(Tile tile) {
    int step = boardwidth;
    int index = tile.index;
    int osten = index + 1;
    int westen = index - 1;
    int sueden = index + step;
    int norden = index - step;

    int neighbour = osten;
    if (neighbour % step > index % step && neighbour < boardheight * step) {
      print("found neighbour" + HimmelsRichtung.Westen.index.toString());
      Tile nbtile = gameBoard[neighbour];
      nbtile.bonusreceived += tile.bonusgiven;

      if (tile.type == TileType.occupied) {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Westen.index] = true;
      } else {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Westen.index] = false;
      }
      print("bonus received: " + nbtile.bonusreceived.toString());

      setState(() {
        this.gameBoard[neighbour] = nbtile;
      });
    }

    neighbour = westen;
    if (neighbour % step < index % step && neighbour >= 0) {
      print("found neighbour" + HimmelsRichtung.Osten.index.toString());

      Tile nbtile = gameBoard[neighbour];
      nbtile.bonusreceived += tile.bonusgiven;

      if (tile.type == TileType.occupied) {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Osten.index] = true;
      } else {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Osten.index] = false;
      }
      print("bonus received: " + nbtile.bonusreceived.toString());

      setState(() {
        this.gameBoard[neighbour] = nbtile;
      });
    }
    neighbour = sueden;
    if (neighbour <= boardheight * step) {
      print("found neighbour" + HimmelsRichtung.Norden.index.toString());

      Tile nbtile = gameBoard[neighbour];
      nbtile.bonusreceived += tile.bonusgiven;

      if (tile.type == TileType.occupied) {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Norden.index] = true;
      } else {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Norden.index] = false;
      }
      print("bonus received: " + nbtile.bonusreceived.toString());

      setState(() {
        this.gameBoard[neighbour] = nbtile;
      });
    }
    neighbour = norden;
    if (neighbour >= 0) {
      print("found neighbour" + HimmelsRichtung.Sueden.index.toString());

      Tile nbtile = gameBoard[neighbour];
      nbtile.bonusreceived += tile.bonusgiven;

      if (tile.type == TileType.occupied) {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Sueden.index] = true;
      } else {
        nbtile.bonusesfromDirectionNOSW[HimmelsRichtung.Sueden.index] = false;
      }
      print("bonus received: " + nbtile.bonusreceived.toString());

      setState(() {
        this.gameBoard[neighbour] = nbtile;
      });
    }
  }

  _setGameBoard(List<Tile> newGameBoard) {
    setState(() {
      this.gameBoard = newGameBoard;
    });
  }

  /// List of Items

  /// Getter (number of items)

  /// Helper method to add an Item

  @override
  Widget build(BuildContext context) {
    return new GameInfoInherited(
      data: this,
      child: widget.child,
    );
  }
}
