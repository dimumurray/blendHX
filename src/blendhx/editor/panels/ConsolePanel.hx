package blendhx.editor.panels;
import flash.text.TextFieldType;
import flash.text.TextField;

import blendhx.editor.spaces.*;

import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
/**
* @author 
 */
class ConsolePanel extends Panel
{
	public var log_textfield:TextField;
	
	private static var instance:ConsolePanel;
	public static function getInstance():ConsolePanel
  	{
    	if (instance == null)
          return instance = new ConsolePanel();
      	else
          return instance;
  	}	
	
	
	public function new() 
	{
		super("Console", Space.SPACE_WIDTH);
		initialize();
		haxe.Log.trace = log;
	}
	
	private function initialize()
	{
		var t:TextField = new TextField();
		var tf:TextFormat = new TextFormat();

		tf.align = TextFormatAlign.LEFT;
		t.autoSize = TextFieldAutoSize.LEFT;
		tf.font = "Segoe UI";
		tf.color = 0xa0a0a0;
		t.defaultTextFormat = tf;
		t.width = 170;
		t.height = _height;
		t.selectable = true;
		t.type = TextFieldType.INPUT;
		t.y = Space.GetSpace(Space.HEADER)._height;
		t.text = "Log console initialized. Use trace(object:Dynamic, color:UInt=0xa0a0a0) to use.\n";
		addChild(t);
		t.x = 5;
		
		log_textfield = t;
	}
	public function clear():Void
	{
		log_textfield.text = "";
	}
	
	public function log( v : Dynamic, ?inf : haxe.PosInfos ):Void
	{
		var oldtf:TextFormat = log_textfield.defaultTextFormat;
		if(inf.customParams != null)
		{
			var newtf:TextFormat = new TextFormat();
			newtf.font = "Segoe UI";
			newtf.color = inf.customParams[0];
			log_textfield.defaultTextFormat = newtf;
		}
			
		log_textfield.appendText( inf.className+", line "+inf.lineNumber+": " +Std.string (v) +'\n');
		log_textfield.defaultTextFormat = oldtf;
	}
	
	override public function drawGraphics():Void
	{}

}