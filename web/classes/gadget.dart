library Gadget;

import 'gamedata.dart';
import 'item.dart';

class Gadget extends Item {
  String name;
  String color;
  List messages;
  
  
  Gadget({String name, int posX, int posY}) : super(posX, posY) {
    
    Map gadgetData = GameData.items['gadgets'][name];
    
    this.width = gadgetData['width'];
    this.height = gadgetData['height'];
    
    this.name = name;
    
  }
  
}