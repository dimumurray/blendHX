package blendhx.editor.spaces;

import blendhx.core.systems.RenderingSystem;
import blendhx.core.*;
import blendhx.core.components.Camera;
import blendhx.editor.uicomponents.*;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3D;
import openfl.display.Stage3D;
import openfl.display.Stage;
import openfl.display3D.Context3DBlendFactor;
import openfl.text.TextFormatAlign;

/**
* @author 
 */

class ViewportSpace extends Space
{
	public var triangles:UInt=0;
 	private var triangles_label:SimpleTextField;
  	
	public function new()
	{
		super();
		type = Space.VIEWPORT;
		
		
		/*triangles_label = new SimpleTextField(TextFormatAlign.LEFT);
		triangles_label.y = 15;
		triangles_label.textColor = 0xaaaaaa;
		addChild(triangles_label);*/
	}
	
	
	//when spaces are resized, this one need specefic attention to configure rendering dimensions
	override public function resize()
	{
		super.resize();
		
		stage.stage3Ds[0].x = x;
		stage.stage3Ds[0].y = Space.GetSpace(Space.HEADER)._height;
		
		var context3D:Context3D = RenderingSystem.getInstance().context3D;
		if(context3D!=null)
			context3D.configureBackBuffer(Std.int(_width), Std.int(_height), 4, true);
		
		var camera:Camera = Scene.getInstance().activeCamera;
		if(camera!=null)
			camera.resize(Std.int(_width), Std.int(_height));
	}
	
	
    override public function drawGraphics()
	{/*empting default background rendering*/}
}
