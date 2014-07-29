package com.blendhx.editor.panels;
import flash.display.Sprite;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import com.blendhx.editor.Selection;
/**

 * GPL

 */
class DragableItem extends Sprite
{
	public var dragValue:Dynamic;
	public var dragText:String="";
	public var dragType:UInt=0;
	public var dragGraphic:BitmapData;
	private var isPoterntialyDragging:Bool;
	
	public function new()
	{
		super();
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, reparentTarget);
	}
	private function onMouseDown(e:MouseEvent):Void
	{
		isPoterntialyDragging = true;

	}
	private function onMouseOut(e:MouseEvent):Void
	{
		if( e.buttonDown && Selection.dragObject == null && isPoterntialyDragging)
			Selection.SetDragObject(this);
		
				
		isPoterntialyDragging = false;
	}
	private function reparentTarget(e:MouseEvent):Void
	{
	}
}