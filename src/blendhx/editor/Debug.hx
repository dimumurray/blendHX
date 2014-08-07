package blendhx.editor;
import blendhx.editor.spaces.Space;

import blendhx.core.*;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
/**
* @author 
 */
class Debug
{
	private static var t:TextField;
	private static var objects:UInt = 0;
	
	static public function Clear():Void
	{
		if (t == null)
			return;
		t.text = "";
	}
	
	static public function Log(s:String):Void
	{
		
		if (t == null)
		{
			t = new TextField();
			var tf:TextFormat = new TextFormat();

			tf.align = TextFormatAlign.LEFT;
			t.autoSize = TextFieldAutoSize.LEFT;
			tf.font = "Segoe UI";
			tf.color = 0x666666;
			t.defaultTextFormat = tf;
			t.width = 170;
			t.height = 150;
			t.selectable = false;
			t.y = Space.GetSpace(Space.HEADER)._height;
			t.text = "";
			Lib.current.stage.addChild(t);
		}
		t.x = Space.GetSpace(Space.VIEWPORT).x;
		t.appendText(s+"\n");
		
	}
	static public function NewObject():Void
	{
		Clear();
		objects++;
		Log(objects + " Objects" );
		
	}
	
}