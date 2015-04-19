library Canvas;

import 'dart:html';
import 'message.dart';
import 'choice.dart';
import 'room.dart';

abstract class Canvas {
  
  static CanvasRenderingContext2D _context;
  
  // TODO: get screen size and define canvas size
  
  static int canvasWidth = 600;
  static int canvasHeight = 400;

  // MESSAGE BOARD
  static double _boardWidth = ( canvasWidth * 2 ) / 3;
  static double _boardHeight = ( canvasHeight * 2 ) / 3;
  static double _boardPosX = ( canvasWidth - _boardWidth ) / 2;
  static double _boardPosY = ( canvasHeight - _boardHeight ) / 2;
  
  
  static get context {
    return _context;
  }
  
  static create() {
    DivElement canvasDiv = querySelector('#canvas');
    CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
    _context = canvas.context2D;
    canvas.addEventListener('mousedown', _getPosition, false);
    canvasDiv.append(canvas);
  } 
  
  // MOUSE EVENTS
  static void _getPosition(event) {
    int clickX = event.client.x - event.currentTarget.offsetLeft;
    int clickY = event.client.y - event.currentTarget.offsetTop;
    
    _triggerEvent(clickX, clickY);    
  }
  
  static void _triggerEvent(int clickX, int clickY) {
    if (Message.isMessageActive) {
      Message.nextMessage();
    }
    
    else if (Choice.isChoiceActive) {
      Choice.submitChoice(clickX, clickY); 
    }
    
    else {    
      Room.roomAction(clickX, clickY);
    }
  }
  
  // DRAW METHODS
  static void drawMessageBoard() {
    _context.setFillColorRgb(255, 255, 255);
    _context.setStrokeColorRgb(0, 0, 0);
    _context.fillRect(_boardPosX, _boardPosY, _boardWidth, _boardHeight);
    _context.strokeRect(_boardPosX, _boardPosY, _boardWidth, _boardHeight);
  }
  
  
  static void drawMessage(String text) {
    
    double maxWidth = _boardWidth - 30;
    double textX = _boardPosX + 15;
    double textY = _boardPosY + 20;
    int lineHeight = 20;
    
    List words = text.split(' ');
    int wordsLength = words.length;
    String line = '';
    
    _context.setFillColorRgb(0, 0, 0);
    _context.font = '16pt Calibri';
    _context.textAlign = 'start';
    
    
    for (int i = 0; i < wordsLength; i++) {
      String testLine = line + words[i] + ' ';
      TextMetrics metrics = _context.measureText(testLine);
      double textWidth = metrics.width;      
      
      if (textWidth > maxWidth && i > 0) {
        _context.fillText(line, textX, textY);
        line = words[i] + ' ';
        textY += lineHeight;
      }
      else {
        line = testLine;
      }
    }
    _context.fillText(line, textX, textY);
  }
  
  static void drawChoices(List<String> options) {
    int oLength = options.length;
    // text positions
    double textPosLeftX = _boardPosX + ( _boardWidth / 4 );
    double textPosRightX = textPosLeftX + ( _boardWidth / 2 );
    double textPosY = _boardPosY + _boardHeight - ( (oLength / 2).round() * 50 );
    // textbox properties
    int boxHeight = 50;
    double boxWidth = ( _boardWidth / 2 ) - 20;
    double boxPosLeftX = _boardPosX + 10;
    double boxPosRightX = boxPosLeftX + ( _boardWidth / 2 );
    double boxPosY = textPosY - ( boxHeight / 2 );
    
    Choice.setOptionSize(boxWidth, boxHeight);
    
    _context.textAlign = 'center';   
    
    for (int i = 0; i < oLength; i++) {
      
      if (i % 2 == 0) {
        _context.strokeRect(boxPosLeftX, boxPosY, boxWidth, boxHeight);
        _context.fillText(options[i], textPosLeftX, textPosY);
        
        Choice.fillChoiceOptions(boxPosLeftX, boxPosY);
      }
      else {
        _context.strokeRect(boxPosRightX, boxPosY, boxWidth, boxHeight);
        _context.fillText(options[i], textPosRightX, textPosY);
        
        Choice.fillChoiceOptions(boxPosRightX, boxPosY);
        
        textPosY += 50;
        boxPosY += 50;
      }
    }   
  } 
}