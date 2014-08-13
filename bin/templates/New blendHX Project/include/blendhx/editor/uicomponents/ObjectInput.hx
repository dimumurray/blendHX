package blendhx.editor.uicomponents;
import blendhx.core.components.Entity;
import blendhx.editor.assets.*;

import blendhx.editor.panels.HierarchyItem;
import blendhx.editor.panels.Panel;
import blendhx.editor.panels.DragableItem;
import blendhx.core.*;
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

/*
This special UIElement let's user drag and drop Draggable items as the value
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
	private var text:String="";
	
	private var icon:Sprite;
	
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
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		if(hostObject == null)
			hostObject = new DragableItem();
		
		this.mouseChildren = false;
	}
	// setter of the value
	override public function set_value(param:Dynamic) 
	{
		if(param == null)
			return null;
		
		if(hostObject.dragText == "")
			hostObject.dragText = param.toString();
		
		value = param;
		text = param.toString();
		if(text == "[object Entity]")
			text = param.name;
		label.text = param.toString();
		if(label.text == "[object Entity]")
			label.text = param.name;
		
		
		return param; 
	}
	
	override public function resize()
	{
		x = getPositionX(slice, slices);
		
		_width = getWidth(slices);
		drawBox(normal, null);
		
		label.width = _width-40;
		label.x = 20;
	}
	//when mouse is out, show the value of the element as the text
	public function onMouseOut(e:MouseEvent)
	{
		label.text = text;
		drawBox(normal, null);
	}	
	//when mouse is hovered over, check to see if there is a Dragable object dragged over, and if the draggable has the same type as this uiElement, temporarily show it's textValue
	public function onMouseOver(e:MouseEvent)
	{
		if(e.buttonDown == true && Selection.dragObject != null && Selection.dragObject.dragType == type)
			label.text = Selection.dragObject.dragText;

		drawBox(over, null);
		
	}
	//if there is a draggable item released over, fix it's dragValue as the value of this UIElement
	public function onMouseUp(e:MouseEvent)
	{
		if( Selection.dragObject == null || Selection.dragObject.dragType != type)
			return;
		
		hostObject = Selection.dragObject;
		value =  hostObject.dragValue;
		label.text = hostObject.dragText;
		drawBox(over, null);
		
		onChange();
	}

	
	//ceate the text field at element start up
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
	//on startup create the representing icon type
	private inline function drawIcon()
	{
		icon = new Sprite();
		var g:Graphics = icon.graphics;
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(3 , 2 + (16 - type) * 16);
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(Icons, matrix);
		g.drawRect(3,2, 16, 16);
		g.endFill();

		addChild(icon);
	}
	//redrawing the pretty box beneath
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
	
	override public function destroy()
	{
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver );
		removeEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp );
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		removeChild(icon);
		removeChild(label);
		
		icon = null;
		label = null;
		
		onChange = null;
		hostObject = null;
		
		normal = null;
		over = null;
		
		super.destroy();
	}
}