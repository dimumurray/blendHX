package blendhx.editor.panels;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.display.Sprite;
import flash.events.MouseEvent;
import blendhx.editor.assets.Images.RemoveImage;
import blendhx.editor.assets.*;

/**

 * GPL

 */
class RemoveButton extends Sprite
{
	public static var Image:BitmapData = new Images.RemoveImage(0, 0);
	
	private var onClick:Void->Void;
	
	public function new(_onClick:Void->Void, _parent:Sprite) 
	{
		super();
		onClick = _onClick;
		drawGraphic();
		_parent.addChild(this);
		addEventListener(MouseEvent.CLICK, removeComponent );
	}
	
	private function removeComponent(_)
	{
		onClick();
	}
	
	private inline function drawGraphic()
	{
		
		var matrix:Matrix = new Matrix();
		
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(RemoveButton.Image, matrix);
		g.drawRect(0, 0, 16, 16);
		g.endFill();
	}

}