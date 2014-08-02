package com.blendhx.editor.uicomponents;
import flash.events.TimerEvent;
import flash.utils.Timer;

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

/*
a text input in fact is used for entering String values by user, why should i document this?
 */
class TextInput extends UIElement
{
	//the text field
	public var label:SimpleTextField;
	//the state colors
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var click:Array<UInt> = [0x868686, 0x969696];
	//call back function to inform of a change to value caused by user
	private var onChange:Void->Void;
	//wheather or not user is editing the text
	private var editing:Bool;
	
	public function new(_text:String, slice:UInt, slices:UInt, _y:Float, _onChange:Void->Void, _panel:Panel) 
	{
		super(slice, slices);
		
		value = _text;
		onChange = _onChange;
		y = _y;
		
		//add this to the list of UIElements of the parent panel
		_panel.addUIElement(this);
		
		//create text field
		drawText();
		//resize element once frist
		resize();
		
		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		addEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		label.addEventListener(Event.CHANGE, updateValue);
		addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		
		updateValue(null);
	}
	
	//a little setter of the value
	override public function setValue(param:Dynamic)
	{
		if(param == null)
			param = "null";
		value = param;
		label.text = value;
	}
	
	//su upon resize, redraw the box
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
	// when Enter is pressed, lock the element and fix the types string as the value
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
	
	//let the user edit the value by clicking the component
	public function onMouseDown(e:MouseEvent)
	{
		flash.Lib.current.stage.focus = label;
		editing = true;
		label.text = value;
		label.setSelection(0, label.length);
		drawBox(click, null);
		
		//to avoid textField right click menu to popup, add a timer to do make text selectable few moments later
		var t:Timer = new Timer(0.1, 1);
		t.addEventListener(TimerEvent.TIMER, setLabelToSelectable);
		t.start();
	}
	//we can now make the text selectable safely. if we did it earlier, a nasty system context menu would pop up on Assets panel
	private function setLabelToSelectable(e:TimerEvent)
	{
		var t:Timer = cast(e.target, Timer);
		t.removeEventListener(TimerEvent.TIMER, setLabelToSelectable);
		t.stop();
		t = null;
		label.selectable = true;
	}
	
	public function updateValue(_)
	{
		value = label.text;
	}
	
	//creating the textfield
	private inline function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, value);
		label.width = _width-40;
		label.x = 20;
		label.selectable = false;
		label.height = _height;
		label.type = TextFieldType.INPUT;

		addChild(label);
	}
	//redrawing the pretty box beneath
	private inline function drawBox(state:Array<UInt>, e:MouseEvent)
	{
		if (editing)
		{
			state = click;
		}

		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		g.clear();
		m.createGradientBox(_width, _height, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		g.drawRoundRect(0, 0, _width, _height, 10);
		g.endFill();
	}
	
	override public function destroy()
	{
		removeEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		removeEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		label.removeEventListener(Event.CHANGE, updateValue);
		
		removeChild(label);
		
		onChange = null;
		label = null;
		normal = null;
		over = null;
		click = null;
	
		super.destroy();
	}
}