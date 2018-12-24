import 'package:flutter/material.dart';


enum TileType{
  tillable, tilled, water, path, occupied, planted

}
enum HimmelsRichtung{
  Norden,Osten,Sueden,Westen
}
const List<String> tools = ['Beet','Pflanzen', 'Dekoration', 'Fluss', 'Weg'];

const List<IconData> icons=[Icons.restaurant,Icons.spa,Icons.build,Icons.pool, Icons.drive_eta];