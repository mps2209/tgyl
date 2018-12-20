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
        theme: ThemeData(
          // Define the default Brightness and Colors
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],

          // Define the default Font Family
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
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
  bool showTools = false;

  int _selectedTool = 0;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGridView(),
        _buildUI(),
      ],
    );
  }

  _buildUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildInfoBar(),
        new Row(
          children: <Widget>[
            Expanded(
              child: Container(),
            )
          ],
        ),
        _buildToolBar()
      ],
    );
  }

  _buildToolButton() {
    return GestureDetector(
      child: Icon(icons[_selectedTool]),
      onTap: _settingsTapped(),
    );
  }

  _settingsTapped() {
    setState(() {
      showTools = !showTools;
    });
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

  _buildInfoBar() {
    final GameInfoState state = GameInfo.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.only(top: 20.0),
          child: new Text(
            "Gold: " + state.gold.toString(),
            style: new TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontStyle: FontStyle.normal,
            ),
          ),
        )
      ],
    );
  }

  _buildGridView() {
    final GameInfoState state = GameInfo.of(context);

    return Column(
      children: <Widget>[
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
        ),
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
      decoration: _getColor(state.getGameBoard()[index]),
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
          state.addToGold(tile.getGold());
          tile.harvestable = false;
          newtype = TileType.tillable;
          tile.checkLvlUp();
        }
        break;
    }
    tile.type = newtype;
    state.setTile(tile.index, tile);
    return tile;
  }

  BoxDecoration _getColor(Tile tile) {
    switch (tile.type) {
      case TileType.water:
        return new BoxDecoration(
          color: Colors.blue,
          border: new Border.all(color: Colors.blueAccent),
        );
        break;
      case TileType.occupied:
        return new BoxDecoration(
          color: Colors.red,
          border: new Border.all(color: Colors.redAccent),
        );
        break;
      case TileType.path:
        return new BoxDecoration(
          color: Colors.grey,
          border: new Border.all(color: Colors.blueGrey),
        );
        break;
      case TileType.tilled:
        return new BoxDecoration(
          color: Colors.brown,
          border: new Border.all(color: Colors.black),
        );
        break;
      case TileType.tillable:
        return new BoxDecoration(
          color: Colors.green,
          border: new Border.all(color: Colors.greenAccent),
        );
        break;
      case TileType.planted:
        return new BoxDecoration(
          color: Colors.brown,
          border: new Border.all(color: Colors.black),
        );
        break;
    }
    return null;
  }
}
