import 'package:flutter/material.dart';


enum TileType{
  tillable, tilled, water, path, occupied, planted

}
enum HimmelsRichtung{
  Norden,Osten,Sueden,Westen
}
const List<String> tools = ['Beet', 'Fluss', 'Weg', 'Dekoration','Pflanzen'];

const List<IconData> icons=[Icons.restaurant,Icons.pool,Icons.drive_eta,Icons.build,Icons.spa];