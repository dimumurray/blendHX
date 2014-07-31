package com.blendhx.editor.spaces;

import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.core.*;
import com.blendhx.core.components.Camera;
import com.blendhx.editor.uicomponents.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3D;
import flash.display.Stage3D;
import flash.display.Stage;
import flash.display3D.Context3DBlendFactor;
import flash.text.TextFormatAlign;

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
		
		var camera:Camera = RenderingSystem.getInstance().camera;
		if(camera!=null)
			camera.resize(Std.int(_width), Std.int(_height));
	}
	
	
    override public function drawGraphics()
	{/*empting default background rendering*/}
}