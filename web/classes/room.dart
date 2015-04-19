library Room;

import 'dart:html';
import 'gamedata.dart';
import 'gamestate.dart';
import 'item.dart';
import 'furniture.dart';
import 'gadget.dart';
import 'person.dart';
import 'door.dart';
import 'canvas.dart';
import 'message.dart';


abstract class Room {
  static String _name;
  static Map _roomItems;
  static List<Item> _items = new List<Item>();
  static Map _rooms = GameData.rooms;
  
  static get name {
    return _name;
  }
  
  static get items {
    return _items;
  }
  
  static _decorateRoom() {
    
    // fill up with furniture
    if (_roomItems.containsKey('furniture')) {
      
      List furn = _roomItems['furniture'];
      int furnLength = furn.length;
      
      for (int i = 0; i < furnLength; i++) {
        
        _items.add(new Furniture(
            name: furn[i]['name'],
            posX: furn[i]['posX'],
            posY: furn[i]['posY']
            ));
      }
    }
    
    // fill up with gadgets
    if (_roomItems.containsKey('gadgets')) {
      List gadgets = _roomItems['gadgets'];
      int gadLength = gadgets.length;
      
      for (int i = 0; i < gadLength; i++) {
        
        _items.add(new Gadget(
            name: gadgets[i]['name'],
            posX: gadgets[i]['posX'],
            posY: gadgets[i]['posY']
            ));
      }
    }
    
    // fill up with persons
    if (_roomItems.containsKey('persons')) {
      List persons = _roomItems['persons'];
      int persLength = persons.length;
      
      for (int i = 0; i < persLength; i++) {
        
        _items.add(new Person(
            name: persons[i]['name'],
            posX: persons[i]['posX'],
            posY: persons[i]['posY']
            ));
      }
    }
    
    // fill up with doors
    if (_roomItems.containsKey('doors')) {
      _roomItems['doors'].forEach((k, v) {
        
        String newState = "gameLoaded"; // default state
        
        if (v.containsKey('state')) {
          newState = v['state']; 
        }
        
        _items.add(new Door(direction: k, state: newState, posX: v['posX'], posY: v['posY']));
      });
    }
  
    
    _drawRoom();
    
  }
  
  
  static _drawRoom() {
    int itemsLength = _items.length;
    
    for (int i = 0; i < itemsLength; i++) {
      Item it = _items[i];
      
      Canvas.context.strokeRect(it.posX, it.posY, it.width, it.height);
    }
  }
  
  static _clearRoom() {
    Canvas.context.clearRect(0, 0, 600, 400);
  }
  
  static reDrawRoom() {
    _clearRoom();
    _drawRoom();
  }
  
  static setRoom(String roomName) {
    _clearRoom();
    _items.clear();
    _name = roomName;
    
    var roomInput = querySelector('#toolbar-room>.room-name');
    roomInput.value = roomName;
    
    _roomItems = _rooms[roomName]['items'];
    _decorateRoom();
  }

  static roomAction(int clickX, int clickY) {
    
    int itemsLength = items.length;
    
    for (int i = 0; i < itemsLength; i++) {
      Item it = items[i];
      
      if(clickY > it.posY
          && clickY < it.posY + it.height
          && clickX > it.posX
          && clickX < it.posX + it.width) {
        
        if(it is Door) {
          
          bool isAccessible = true;
          
          if (it.state != "gameLoaded") {
            isAccessible = GameState.checkState(it.state);
          }
          
          if (isAccessible) {
            
            // check if door is a gamestate changer
            if (GameData.gamestateChangers.containsKey(_name) && GameData.gamestateChangers[_name].containsKey(it.direction)) {
              GameState.setState(GameData.gamestateChangers[_name][it.direction]);
            }
            
            Room.setRoom(it.direction);
          }
          else {
            Message.toggleMessage(room: _name, trigger: it.direction);
          }
          
          break;
        }
        
        else {
          
          Message.toggleMessage(room: _name, trigger: it.name);
          
          // check if item is a gamestate changer
          if (GameData.gamestateChangers.containsKey(_name) && GameData.gamestateChangers[_name].containsKey(it.name)) {
            GameState.setState(GameData.gamestateChangers[_name][it.name]);
          }
          
          break;
        }
      }
    }
  }
  
  
}






