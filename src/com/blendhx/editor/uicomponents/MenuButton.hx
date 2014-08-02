package com.blendhx.editor.uicomponents;
import flash.text.TextFieldAutoSize;

import com.blendhx.editor.panels.Panel;
import com.blendhx.core.*;

import flash.display.DisplayObjectContainer;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.display.Graphics;
import flash.text.TextField;
import flash.display.Sprite;

/**
* @author 
 */
class MenuButton extends UIElement
{
	private var label:SimpleTextField;
	private var normal:Array<UInt> = [0x707070, 0x717171];
	private var over:Array<UInt> = [0x567fc1, 0x567fc1];
	private var click:Array<UInt> = [0x567fc1, 0x567fc1];
	public var text:String;
	private var onClick:Void->Void;
	
	public function new(text:String, _y:Float,  onClick:Void->Void, _panel:Panel) 
	{
		super(1, 1);
		
		y = _y;
		this.text = text;
		this.onClick = onClick;

		
		_panel.addUIElement(this);
		drawText();
		resize();
		drawBox(normal, null);
		

		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	override public function resize()
	{
		
		_width = label.width + 10;
		
	}
	
	private function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, text);
		label.autoSize = TextFieldAutoSize.LEFT;
		//label.width = _width;
		label.height = 20;
		label.x = 5;
		addChild(label);
	}
	
	private function onMouseDown(_)
	{
		onClick();
		//drawBox(normal, null);
	}
		
	private  function drawBox(state:Array<UInt>, _)
	{
		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		
		g.clear();
		m.createGradientBox(_width*2, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(0, 0, 0);
		g.drawRoundRect(0, 0, _width, 20, 12);
		g.endFill();
	}
	
	override public function destroy()
	{
		removeEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		removeChild(label);
		
		label = null;
		onClick = null;
		normal = null;
		over = null;
		over = click;
		
		super.destroy();
	}
}