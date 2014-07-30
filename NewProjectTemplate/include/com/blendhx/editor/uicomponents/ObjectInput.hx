package com.blendhx.editor.uicomponents;
import com.blendhx.core.components.GameObject;
import com.blendhx.editor.assets.*;

import com.blendhx.editor.panels.HierarchyItem;
import com.blendhx.editor.panels.Panel;
import com.blendhx.editor.panels.DragableItem;
import com.blendhx.core.*;
import flash.Lib;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;
import flash.text.TextFieldType;
import flash.events.Event;
import flash.display.DisplayObjectContainer;
import flash.display.BitmapData;
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
class ObjectInput extends UIElement
{
	public static var Icons:BitmapData = new Images.FileImages(0, 0);
	
	private var label:SimpleTextField;
	private var normal:Array<UInt> = [0xa1a1a1, 0xb1b1b1];
	private var over:Array<UInt> = [0xb0b0b0, 0xc0c0c0];
	private var onChange:Void->Void;
	private var type:UInt;
	
	private var hostObject:DragableItem;
	
	public function new(type:UInt, slice:UInt, slices:UInt, _y:Float, onChange:Void->Void, _panel:Panel) 
	{
		super(slice, slices);
		
		this.onChange = onChange;
		this.type = type;
		y = _y;
		
		_panel.addUIElement(this);
		
		drawText();
		drawIcon();
		resize();
		
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp );
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		if(hostObject == null)
			hostObject = new DragableItem();
	}
	override public function setValue(param:Dynamic)
	{
		if(param == null) param = "";
		if(hostObject.dragText == "")
			hostObject.dragText = param.toString();
		
		value = param;
		label.text = param.toString();
		onChange();
	}
	
	override public function resize()
	{
		x = getPositionX(slice, slices);
		
		_width = getWidth(slices);
		drawBox(normal, null);
		
		label.width = _width-40;
		label.x = 20;
	}
	
	public function onMouseOut(e:MouseEvent)
	{
			
		label.text = hostObject.dragText;
		drawBox(normal, null);
	}	
	
	public function onMouseOver(e:MouseEvent)
	{
		if(e.buttonDown == true && Selection.dragObject != null && Selection.dragObject.dragType == type)
			label.text = Selection.dragObject.dragText;

		drawBox(over, null);
		
	}
	
	public function onMouseUp(e:MouseEvent)
	{
		if( Selection.dragObject == null || Selection.dragObject.dragType != type)
			return;
		
		hostObject = Selection.dragObject;
		setValue( hostObject.dragValue );
		label.text = hostObject.dragText;
		drawBox(over, null);
	}
	
	public function onMouseDown(e:MouseEvent)
	{
	}
	
	public function updateValue(_)
	{
		
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
	
	private inline function drawIcon()
	{
		var icon:Sprite = new Sprite();
		var g:Graphics = icon.graphics;
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(3 , 2 + (16 - type) * 16);
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(Icons, matrix);
		g.drawRect(3,2, 16, 16);
		g.endFill();

		addChild(icon);
	}
	
	private inline function drawBox(state:Array<UInt>, _)
	{
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