library InterfaceRoom;

import 'dart:html';
import 'gamedata.dart';
import 'room.dart';


abstract class InterfaceRoom {
  static Map _rooms = GameData.rooms;
  static List _eventListeners = new List();
  
  static void initialise() {
    _loadRoomList();
    _setupEventListeners();
  }
  
  static void _loadRoomList() {
    SelectElement selectRoom = querySelector('#toolbar-room>.select-room');
    OptionElement roomOption = new OptionElement();
    
    _rooms.forEach((k, v) {
      roomOption.value = k;
      roomOption.innerHtml = k;
      selectRoom.append(roomOption.clone(true));
    });
  }
  
  static _addNewRoom() {
    SelectElement selectRoom = querySelector('#toolbar-room>.select-room');
    selectRoom.value = '';
    String roomName = '';
    
    for (var i = 0; i < 1000; i++) {    
      if (_rooms['newRoom$i'] != null) {
        continue;
      }
      else {
        _rooms['newRoom$i'] = {'items':{}};
        roomName = 'newRoom$i';
        break;
      }    
    }
    
    Room.setRoom(roomName);
    
    // TODO clear input fields
  }
  
  static void _setupEventListeners() {
    SelectElement selectRoom = querySelector('#toolbar-room>.select-room');
    ButtonElement newRoomButton = querySelector('#toolbar-room>.new-room');
    
    var selectRoomListener = selectRoom.onChange.listen((e) {
      if (e.target.value == '') { return; }
      
      else {
        Room.setRoom(e.target.value);
      }
    });
    
    var newRoomListener = newRoomButton.onClick.listen((e) => _addNewRoom());
    
    
    _eventListeners.add(selectRoomListener);
    _eventListeners.add(newRoomListener);
    
  }
  
}