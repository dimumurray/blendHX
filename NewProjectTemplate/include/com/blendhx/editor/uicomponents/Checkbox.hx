package com.blendhx.editor.uicomponents;
import flash.display.Graphics;
import flash.geom.Matrix;

import com.blendhx.editor.panels.Panel;
import com.blendhx.editor.assets.*;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
/**

 * GPL

 */
class Checkbox extends UIElement
{
	private var label:SimpleTextField;
	private var onChange:Void->Void;
	
	public static var Images:BitmapData = new Images.CheckboxImages(0, 0);
	

	public function drawText() 
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, "");
		label.x = 20;
		label.autoSize = TextFieldAutoSize.LEFT;
		addChild(label);
	}	
	
	
	public function new(_text:String, slice:UInt, slices:UInt, _y:Float, _onChange:Void->Void, _panel:Panel) 
	{
		super(slice, slices);
		
		onChange = _onChange;
		y = _y;
		value = false;
		
		if(panel != null)_panel.addUIElement(this);
		
		drawText();
		setValue(false);
		resize();
		
		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(32) );
		addEventListener(MouseEvent.MOUSE_UP, drawBox.bind(32) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(0) );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	
	override public function setValue(param:Dynamic)
	{
		value = param;
		drawBox(0, null);
	}
	
	public function onMouseDown(e:MouseEvent)
	{
		value = !value;
		drawBox(0, null);
		onChange();
	}
	
	private inline function drawBox(state:UInt, e:MouseEvent)
	{
		if(value == true)
			state = 16;
		
		var matrix:Matrix = new Matrix();
  		matrix.translate(state, 0);
		
		
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(Checkbox.Images, matrix);
		g.drawRect(0, 0, 16, 16);
		g.endFill();
	}
	
	override public function resize()
	{
		if(panel != null)
			super.resize();
	}

}