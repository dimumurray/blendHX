package com.blendhx.editor.uicomponents;

import com.blendhx.core.*;
import com.blendhx.editor.panels.Panel;
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

/*
so flexible numver input, in that it have many multiple visual representations based on Static valies set upon instantiation 
passing static variables of NumberInput class as the last argument, will make the underlying box graphic to round differently
}

 */
class NumberInput extends UIElement
{
	private var label:SimpleTextField;
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var click:Array<UInt> = [0x868686, 0x969696];
	private var text:String;
	private var onChange:Void->Void;
	private var editing:Bool;
	private var rounding:Array<Float>;
	
	//each will make the UIElement look like differently, choose based on the position used among other UIElements
	public static var ROUND_UP:Array<Float> = [13, 13, 0 , 0];
	public static var ROUND_DOWN:Array<Float> = [0, 0, 13 , 13];
	public static var ROUND_BOTH:Array<Float> = [20, 20, 20 , 20];
	public static var ROUND_NONE:Array<Float> = [0, 0, 0 , 0];
	
	public function new(_text:String, slice:UInt, slices:UInt, _y:Float, _onChange:Void->Void, _panel:Panel, rounding:Array<Float>) 
	{
		super(slice, slices);
		
		text = _text;
		onChange = _onChange;
		this.rounding = rounding;
		y = _y;
		value = 0.0;
		
		_panel.addUIElement(this);
		
		drawText();
		resize();
		
		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		addEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(Event.CHANGE, onTextChange);
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		updateValue();
	}
	
	//a little value setter, and showing only 2 decimals of the float value
	override public function set_value(param:Dynamic) 
	{
		if(editing)
			return null;
		
		value = param;
		if(label != null)
			label.text = text+": "+ Utils.PrintFloat( param, 2 );
		return param; 
	}
	
	//re draw the graphics and resize the textfield
	override public function resize()
	{
		x = getPositionX(slice, slices);
		
		_width = getWidth(slices);
		drawBox(normal, null);
		
		label.width = _width-30;
		label.x = 15;
	}
	//when key is pressed and it's Enter, fix the value
	private function onKeyDown(e:KeyboardEvent)
	{
		if (e.keyCode == Keyboard.ENTER)
		{
			editing = false;
			updateValue();
			drawBox(normal, null);
			label.selectable = false;
		}
		if (!editing)
		{
			updateValue();
		}
	}
	//when mouse is down over this, if its presed at center, make the textfield inside editable, else increase or decrease value based on mouse position 
	public function onMouseDown(e:MouseEvent)
	{
		drawBox(click, null);
		if (!editing && e.localX <  20)
		{
			value --;
			updateValue();
			
		}
		else if (!editing && e.localX > _width - 20)
		{
			value ++;
			updateValue();
			
		}
		else 
		{
			editing = true;
			label.text = Utils.PrintFloat(value, 2);
			label.selectable = true;
			label.setSelection(0, label.length);
			drawBox(click, null);
		}

	}
	
	public function updateValue()
	{
		var newValue:Float = Std.parseFloat(label.text);
		if (Std.string(newValue)!="NaN")
		{
			value = newValue;
		}
		label.text = text+": "+ Utils.PrintFloat( value, 2 );
		onChange();
	}
	//when text inside is changed, do some checking on the entered value
	private function onTextChange(_)
	{
		

	}
	//creating the textfield at start up
	private inline function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, text);
		label.width = _width-30;
		label.x = 15;
		label.selectable = true;
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
		g.drawRoundRectComplex(0, 0, _width, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		g.endFill();
		
		if (!editing)
		{
			drawHandles();
		}
		
	}
	//drawing the increase and decrease graphics
	private function drawHandles()
	{
		var g:Graphics = graphics;
		g.beginFill(0x767676);
		g.lineStyle(0, 0, 0);
		g.moveTo(8, 10);
		g.lineTo(12, 14);
		g.lineTo(12, 6);
		g.lineTo(8, 10);
		g.moveTo(_width-8, 10);
		g.lineTo(_width-12, 14);
		g.lineTo(_width-12, 6);
		g.lineTo(_width-8, 10);
		g.endFill();
	}
	//some clean up for GC
	override public function destroy()
	{
		removeEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		removeEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(Event.CHANGE, onTextChange);
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		removeChild(label);
		
		label = null;
		onChange = null;
		normal = null;
		over = null;
		click = null;
		rounding = null;
		
		super.destroy();
	}
}