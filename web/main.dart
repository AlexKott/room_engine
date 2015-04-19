// Copyright (c) 2015, Alex Kott and Alina Beck. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'classes/room.dart';
import 'classes/gamedata.dart';
import 'classes/canvas.dart';


void main() {
  
  Canvas.create();
  
  GameData.initialise();

  Room.setRoom('bedroom');
}


