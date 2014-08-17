package blendhx.editor.uicomponents;

import openfl.text.Font;
import blendhx.editor.assets.EditorFont;
import blendhx.core.*;
import openfl.text.TextFormatAlign;
import openfl.text.GridFitType;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;


class SimpleTextField extends TextField
{
	
	public function new(_align:TextFormatAlign, _text:String="",_x:Float=0, _y:Float=0, _selectable:Bool=false)
	{
		super();

		Font.registerFont(EditorFont);

		var textFormat:TextFormat = new TextFormat();
		textFormat.font = new EditorFont().fontName;
		textFormat.align = _align;
		
		//embedFonts = true;
		cacheAsBitmap = true;
		multiline = false;
		defaultTextFormat = textFormat;

		selectable = _selectable;
		text = _text;
		x = _x;
		y = _y;
	}
}
