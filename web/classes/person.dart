library Person;

import 'item.dart';

class Person extends Item {
  String name;
  int width = 60;
  int height = 60;
  List messages;
  
  
  Person({String name, int posX, int posY}) : super (posX, posY) {
    
    this.name = name;
  }
  
}