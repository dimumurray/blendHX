package blendhx.editor.uicomponents;
import openfl.text.TextFieldAutoSize;

import blendhx.editor.panels.Panel;
import blendhx.core.*;
import openfl.text.TextFormatAlign;

/**
* @author 
 */
class Label extends UIElement
{
	private var label:SimpleTextField;
	
	public function new(_text:String="text", slice:UInt, slices:UInt, _y:Float, _panel:Panel) 
	{
		super(slice, slices);
		
		panel = _panel;
		y = _y;
		resize();
		
		label = new SimpleTextField(TextFormatAlign.CENTER, _text);
		label.autoSize = TextFieldAutoSize.LEFT;
		addChild(label);
		
		_panel.addUIElement(this);
	}
	
	
	override public function destroy()
	{
		removeChild(label);
		label = null;
		
		super.destroy();
	}
	
}
