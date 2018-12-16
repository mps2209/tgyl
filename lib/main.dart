import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:math';
import 'gameState.dart';
import 'const.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameInfo(
      child: new MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedTool = 0;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
            primaryColor: Colors.white,
            disabledColor: Colors.grey,
          ),
          child: _buildToolBar()),
      body: _buildGridView(),
    );
  }

  _buildToolBar() {
    return new BottomNavigationBar(
      currentIndex: _selectedTool,
      onTap: _onToolTapped,
      items: List.generate(tools.length, (index) {
        return BottomNavigationBarItem(
          activeIcon: new Icon(icons[index], color: Colors.blueAccent),
          title: new Text(tools[index]),
          icon: new Icon(icons[index]),
        );
      }),
    );
  }

  void _onToolTapped(int index) {
    setState(() {
      this._selectedTool = index;
    });
  }

  _buildTools() {
    return Row(
      children: List.generate(tools.length, (index) {
        return Expanded(
          child: Container(
            height: 70.0,
            decoration: new BoxDecoration(
                color: Colors.grey, border: Border.all(color: Colors.black)),
            child: Center(
                child: Text(
              tools[index],
            )),
          ),
        );
      }),
    );
  }

  _buildGridView() {
    final GameInfoState state = GameInfo.of(context);

    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
      crossAxisCount: state.getBoardWidth(),
      // Generate 100 Widgets that display their index in the List
      children: List.generate(state.getBoardWidth() * state.getBoardHeigth(),
          (index) {
        return _buildTile(index);
      }),
    );
  }

  _buildTile(int index) {
    return GestureDetector(
        onTap: () => _tileTapped(index), child: _getTile(index));
  }

  _getTile(int index) {
    final GameInfoState state = GameInfo.of(context);
    return Container(
      child:
          state.getGameBoard()[index] == TileType.planted ? Plant(index) : null,
      decoration: new BoxDecoration(
        color: _getColor(state.getGameBoard()[index]),
        border: new Border.all(color: Colors.greenAccent),
      ),
    );
  }

  _tileTapped(int index) {
    final GameInfoState state = GameInfo.of(context);
    var gameBoard = state.getGameBoard();
    int newTileValue = gameBoard[index].index + 1;
    if (newTileValue >= TileType.values.length) {
      newTileValue = 0;
    }
    TileType changedTile = _getTileAfterAction(gameBoard[index]);
    state.setTile(index, changedTile);
  }

  _getTileAfterAction(TileType tile) {
//    const List<String> tools = ['till', 'dig', 'plaster', 'build','plant'];

    switch (tools[_selectedTool]) {
      case 'till':
        if (tile == TileType.tillable) {
          return TileType.tilled;
        }
        if (tile == TileType.tilled) {
          return TileType.tillable;
        }
        break;
      case 'dig':
        if (tile == TileType.tillable) {
          return TileType.water;
        }
        if (tile == TileType.water) {
          return TileType.tillable;
        }
        break;
      case 'plaster':
        if (tile == TileType.tillable) {
          return TileType.path;
        }
        if (tile == TileType.path) {
          return TileType.tillable;
        }
        break;
      case 'build':
        if (tile == TileType.tillable) {
          return TileType.occupied;
        }
        if (tile == TileType.occupied) {
          return TileType.tillable;
        }
        break;
      case 'plant':
        if (tile == TileType.tilled) {
          return TileType.planted;
        }
        if (tile == TileType.planted) {
          return TileType.tillable;
        }
        break;
    }
    return tile;
  }

  Color _getColor(TileType tile) {
    switch (tile) {
      case TileType.water:
        return Colors.blue;
        break;
      case TileType.occupied:
        return Colors.red;
        break;
      case TileType.path:
        return Colors.grey;
        break;
      case TileType.tilled:
        return Colors.brown;
        break;
      case TileType.tillable:
        return Colors.green;
        break;
      case TileType.planted:
        return Colors.brown;
        break;
    }
    return null;
  }
}

class Plant extends StatefulWidget {
  int tileIndex;
  Plant(int this.tileIndex);
  @override
  State<StatefulWidget> createState() => PlantState(tileIndex);
}

class PlantState extends State<Plant> with TickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
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
    return new FlareActor("assets/plantforthandback.flr",
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
    });
  }
}
