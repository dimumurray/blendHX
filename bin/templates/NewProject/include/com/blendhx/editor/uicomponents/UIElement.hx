package com.blendhx.editor.uicomponents;

import com.blendhx.editor.panels.Panel;
import com.blendhx.core.*;
import flash.display.Sprite;


/**
* @author 
 */
class UIElement extends Sprite
{
	public var slice:UInt;
	public var slices:UInt;
	public var _width:Float;
	public var _height:Float = 20;
	public var paddingX:UInt = 10;
	public var panel:Panel;
	public var value:Dynamic;
	
	public function new(slice:UInt, slices:UInt) 
	{
		super();
		this.slice = slice;
		this.slices = slices;
		
	}
	
	public function setValue(param:Dynamic)
	{
	}
	
	public inline function getWidth(slices:Int):Float
	{
		return (panel._width - (paddingX * (slices +1))) / slices;
	}
	public inline function getPositionX(slice:Int, slices:Int):Float
	{
		return (getWidth(slices)*(slice-1)) + (slice * paddingX);
	}
	public function resize()
	{
		x = getPositionX(slice, slices);
	}
	public function destroy()
	{
		panel = null;
		value = null;
	}
}