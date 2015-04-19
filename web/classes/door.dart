library Door;

import 'item.dart';

class Door extends Item {
  String direction;
  int width = 100;
  int height = 100;
  String state;

  changeRoom() {

  }

  Door ({String direction, String state, int posX, int posY}) : super(posX, posY) {
  
    this.direction = direction;
    this.state = state;
    this.posX = posX;
    this.posY = posY;
    
  }
}
