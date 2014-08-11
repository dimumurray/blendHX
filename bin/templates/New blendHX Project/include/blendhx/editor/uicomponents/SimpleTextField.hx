package blendhx.editor.uicomponents;

import flash.text.Font;
import blendhx.editor.assets.EditorFont;
import blendhx.core.*;
import flash.text.TextFormatAlign;
import flash.text.GridFitType;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;


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
