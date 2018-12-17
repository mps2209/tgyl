import 'package:flutter/material.dart';
import 'gameState.dart';
import 'const.dart';
import 'plant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameInfo(
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
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



  _buildGridView() {
    final GameInfoState state = GameInfo.of(context);

    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 20.0),
                child: new Text("Gold: " + state.gold.toString()),
              )
            ],
        ),
        Expanded(
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this would produce 2 rows.
            crossAxisCount: state.getBoardWidth(),
            // Generate 100 Widgets that display their index in the List
            children: List.generate(
                state.getBoardWidth() * state.getBoardHeigth(), (index) {
              return _buildTile(index);
            }),
          ),
        )
      ],
    );
  }

  _buildTile(int index) {
    return GestureDetector(
        onTap: () => _tileTapped(index), child: _getTile(index));
  }

  _getTile(int index) {
    final GameInfoState state = GameInfo.of(context);
    Tile tile = state.getGameBoard()[index];
    return new Container(
      child: state.getGameBoard()[index].type == TileType.planted
          ? new Plant(index)
          : null,
      decoration: new BoxDecoration(
        color: _getColor(state.getGameBoard()[index].type),
        border: new Border.all(color: Colors.greenAccent),
      ),
    );
  }

  _tileTapped(int index) {
    final GameInfoState state = GameInfo.of(context);
    var gameBoard = state.getGameBoard();
    int newTileValue = gameBoard[index].type.index + 1;
    if (newTileValue >= TileType.values.length) {
      newTileValue = 0;
    }
    Tile changedTile = _getTileAfterAction(gameBoard[index]);
    state.setTile(index, changedTile);
  }

  _getTileAfterAction(Tile tile) {
    final GameInfoState state = GameInfo.of(context);
//    const List<String> tools = ['till', 'dig', 'plaster', 'build','plant'];
    TileType newtype = tile.type;
    switch (tools[_selectedTool]) {
      case 'till':
        if (tile.type == TileType.tillable) {
          newtype = TileType.tilled;
        }
        if (tile.type == TileType.tilled) {
          newtype = TileType.tillable;
        }
        break;
      case 'dig':
        if (tile.type == TileType.tillable) {
          newtype = TileType.water;
        }
        if (tile.type == TileType.water) {
          newtype = TileType.tillable;
        }
        break;
      case 'plaster':
        if (tile.type == TileType.tillable) {
          newtype = TileType.path;
        }
        if (tile.type == TileType.path) {
          newtype = TileType.tillable;
        }
        break;
      case 'build':
        if (tile.type == TileType.tillable) {
          newtype = TileType.occupied;
        }
        if (tile.type == TileType.occupied) {
          newtype = TileType.tillable;
        }
        break;
      case 'plant':
        if (tile.type == TileType.tilled && state.substractFromGold(5)) {
          newtype = TileType.planted;
        }
        if (tile.type == TileType.planted && tile.harvestable) {
          state.addToGold(10);
          tile.harvestable=false;
          state.setTile(tile.index, tile);
          newtype = TileType.tillable;
        }
        break;
    }
    tile.type = newtype;
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
