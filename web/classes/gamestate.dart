library GameState;

import 'gamedata.dart';

abstract class GameState {
  
  // TODO: load states from user cache
  static Map<String, bool> _states = {
    "gameLoaded": true,
    "drankWater": false,
    "answeredPhone": false
  };
  
  static void _changeState(String state) {
    _states[state] = true;
    // TODO: save state to user cache.
  }
  
  static bool checkState(String state) {
    return _states[state];
  }
  
  static void setState (String state) {
    if (!_states[state]) {
      List condition = GameData.gamestateConditions[state]['states'];
      int conditionLength = condition.length;
      bool allowSetState = true;
      
      for (int i = 0; i < conditionLength; i++) {
        if (checkState(condition[i])) continue;
        
        else {
          allowSetState = false;
          break;
        }
      }
      if (allowSetState) {
        _changeState(state);
      }
    }
  }
}