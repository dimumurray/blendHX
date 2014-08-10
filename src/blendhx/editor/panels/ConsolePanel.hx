package blendhx.editor.panels;
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
		t.y = Space.GetSpace(Space.HEADER)._height;
		t.text = "";
		addChild(t);
		t.x = 5;
		
		log_textfield = t;
	}
	public function clear():Void
	{
		log_textfield.text = "";
	}
	
	public function log(object:Dynamic):Void
	{
		log_textfield.appendText( Std.string (object) +'\n');
	}
	
	override public function drawGraphics():Void
	{}

}