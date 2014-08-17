package blendhx.editor.panels;

import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
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
