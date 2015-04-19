library Choice;

import 'gamedata.dart';
import 'gamestate.dart';
import 'room.dart';
import 'message.dart';
import 'canvas.dart';


abstract class Choice {
  static bool isChoiceActive = false;
  
  static Map _choice = new Map();
  
  static List _optionPosList = new List();
  static var _optionWidth;
  static var _optionHeight;
  
  static void toggleChoice(String choiceName) {
    
    List options;
    List optionsTexts = new List<String>();
    List optionsNames = new List<String>();
    int optionsLength = 0;
    
    if (!isChoiceActive) {
      isChoiceActive = true;
    }
    
    _choice = GameData.choices[Room.name][choiceName];
    // contains text, options and impact
    
    options = _choice['options'];
    optionsLength = options.length;
    
    Canvas.drawMessageBoard();
    Canvas.drawMessage(_choice['text']);
    
    
    for(int i = 0; i < optionsLength; i++) {
      options[i].forEach((name, text) { 
        optionsTexts.add(text);
        optionsNames.add(name);
      });
    }
    
    Canvas.drawChoices(optionsTexts);
    
    
  }
  
  static void setOptionSize(width, height) {
    _optionWidth = width;
    _optionHeight = height;
  }
  
  static void fillChoiceOptions(double posX, double posY) {
    _optionPosList.add({
      'posX':posX,
      'posY':posY
    });
  }
  
  static void submitChoice(int clickX, int clickY) {
    
    for (int i = 0; i < _optionPosList.length; i++) {
      var op = _optionPosList[i];
      if (clickY > op['posY']
          && clickY < op['posY'] + _optionHeight
          && clickX > op['posX']
          && clickX < op['posX'] + _optionWidth) {
        _excecuteImpact(i);
        break;
      }
    }
  }
  
  static void _excecuteImpact(i) {
    
    Map decision = new Map();
    
    _choice['options'][i].forEach((name, v) {
      if (name == 'exit') {
        _hideChoice();
      }
      else {
        decision = _choice['impact'][name];
      }
    });

    if (decision.containsKey('gamestate')) {
      GameState.setState(decision['gamestate']);
    }
    
    if (decision.containsKey('message')) {
      isChoiceActive = false;
      Message.toggleMessage(room: Room.name, trigger: decision['message']);
    }
    
    else if (decision.containsKey('choice')) {
      _hideChoice();
      toggleChoice(decision['choice']);
    }
    
    else if (decision.containsKey('exitText')) {
      isChoiceActive = false;
      Message.isMessageActive = true;
      
      Canvas.drawMessageBoard();
      Canvas.drawMessage(decision['exitText']);      
    }
    
  }
  
  static void _hideChoice() {
    Room.reDrawRoom();
    isChoiceActive = false;
  }

}