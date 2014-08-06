package com.blendhx.editor.uicomponents;

import com.blendhx.editor.panels.Panel;
import com.blendhx.core.*;
import flash.display.Sprite;


/*
Base of every User Interface Element in the panels
 */
class UIElement extends Sprite
{
	//defines the current physical horizontal position
	public var slice:UInt;
	//how many total uiElements are there gonna be in this horizonal row
	public var slices:UInt;
	
	public var _width:Float=0;
	public var _height:Float = 20;
	//the padding betweein two UIElements
	public var paddingX:UInt = 10;
	//the panel conraining this element
	public var panel:Panel;
	//the actual value of this element 
	@:isVar public var value(get, set):Dynamic;
	
	//if 999 is passed is the total number of slices, then this element will have no automatic horizontal positions and width set
	public static var NO_SLICE:UInt = 999;
	
	public function new(slice:UInt, slices:UInt) 
	{
		super();
		this.slice = slice;
		this.slices = slices;
	}
	
	//a setter in fact
	public function get_value() { return value; }
	public function set_value(param:Dynamic) 
	{
		value = param;
		return param; 
	}
	
	//little function to tell how wide should this element be in contrast with other elements in the current horrizontal row
	public inline function getWidth(slices:Int):Float
	{
		return (panel._width - (paddingX * (slices +1))) / slices;
	}
	//gives the automatic positioning of  this ui element according to the other elements in this row, padding included!
	public inline function getPositionX(slice:Int, slices:Int):Float
	{
		return (getWidth(slices)*(slice-1)) + (slice * paddingX);
	}
	//reset the positioning and scale
	public function resize()
	{
		x = getPositionX(slice, slices);
	}
	//a little GC
	public function destroy()
	{
		panel = null;
		value = null;
	}
}