package com.blendhx.editor.uicomponents;

import com.blendhx.editor.panels.Panel;
import com.blendhx.core.*;
import flash.Lib;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.text.TextFieldType;
import flash.events.Event;
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
class TextInput extends UIElement
{
	public var label:SimpleTextField;
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var click:Array<UInt> = [0x868686, 0x969696];
	private var onChange:Void->Void;
	
	private var editing:Bool;
	
	public function new(_text:String, slice:UInt, slices:UInt, _y:Float, _onChange:Void->Void, _panel:Panel) 
	{
		super(slice, slices);
		
		value = _text;
		onChange = _onChange;
		y = _y;
		
		_panel.addUIElement(this);
		
		drawText();
		resize();
		
		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		addEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		label.addEventListener(Event.CHANGE, updateValue);
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		updateValue(null);
	}
	override public function setValue(param:Dynamic)
	{
		if(param == null)
			param = "null";
		value = param;
		label.text = value;
	}
	
	override public function resize()
	{
		if(slices!= UIElement.NO_SLICE)
		{
			x = getPositionX(slice, slices);
			_width = getWidth(slices);
		}
			
		drawBox(normal, null);
		
		label.width = _width-10;
		label.x = 5;
		updateValue(null);
		
	}

	private function onKeyDown(e:KeyboardEvent)
	{
		if (e.keyCode == Keyboard.ENTER)
		{
			editing = false;
			updateValue(null);
			drawBox(normal, null);
			label.selectable = false;
			label.setSelection(0, 0);
			onChange();
		}
	}
	
	public function onMouseDown(e:MouseEvent)
	{
		drawBox(click, null);
		
		flash.Lib.current.stage.focus = label;
		editing = true;
		label.text = value;
		label.selectable = true;
		label.setSelection(0, label.length);
		drawBox(click, null);
	}
	
	public function updateValue(_)
	{
		value = label.text;
	}
	
	
	private inline function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, value);
		label.width = _width-40;
		label.x = 20;
		label.selectable = false;
		label.height = 20;
		label.type = TextFieldType.INPUT;

		addChild(label);
	}
	private inline function drawBox(state:Array<UInt>, e:MouseEvent)
	{
		if (editing)
		{
			state = click;
		}

		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		g.clear();
		m.createGradientBox(_width, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		g.drawRoundRect(0, 0, _width, 20, 10);
		g.endFill();
	}
}