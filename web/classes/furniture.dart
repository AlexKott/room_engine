library Furniture;

import 'gamedata.dart';
import 'item.dart';

class Furniture extends Item {
  String name;
  String color;
  List messages;
  
  
  Furniture({String name, int posX, int posY}) : super(posX, posY) {
    
    Map furnitureData = GameData.items['furniture'][name];
    
    this.width = furnitureData['width'];
    this.height = furnitureData['height'];
    
    this.name = name;
    
  }
  
}