package com.blendhx.editor.panels;
import flash.events.Event;
import flash.Vector;

import com.blendhx.editor.Selection;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.assets.FileType;
import com.blendhx.core.*;
import com.blendhx.core.components.Transform;
import com.blendhx.editor.spaces.Space;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;
import flash.text.TextFormatAlign;

/**
* @author 
 */
class TransformPanel extends Panel
{
	var location_x:NumberInput;
	var location_y:NumberInput;
	var location_z:NumberInput;
	var rotation_x:NumberInput;
	var rotation_y:NumberInput;
	var rotation_z:NumberInput;
	var scale_x:NumberInput;
	var scale_y:NumberInput;
	var scale_z:NumberInput;
			
	public function new() 
	{
		super("Transform", Space.SPACE_WIDTH);
		
		var locationLabel:Label = new Label("Location:", 1, 3, 30, this);
		var locationLabel:Label = new Label("Rotation:", 2, 3, 30, this);
		var locationLabel:Label = new Label("Scale:", 3, 3, 30, this);

		location_x = new NumberInput("X", 1, 3, 50, setValues, this, NumberInput.ROUND_UP);
		location_y = new NumberInput("Y", 1, 3, 70, setValues, this, NumberInput.ROUND_NONE);
		location_z = new NumberInput("Z", 1, 3, 90, setValues, this, NumberInput.ROUND_DOWN);
		
		rotation_x = new NumberInput("X", 2, 3 , 50,  setValues, this, NumberInput.ROUND_UP);
		rotation_y = new NumberInput("Y", 2, 3 , 70,  setValues, this, NumberInput.ROUND_NONE);
		rotation_z = new NumberInput("Z", 2, 3 , 90,  setValues, this, NumberInput.ROUND_DOWN);
		
		scale_x = new NumberInput("X", 3, 3 , 50,  setValues, this, NumberInput.ROUND_UP);
		scale_y = new NumberInput("Y", 3, 3 , 70,  setValues, this, NumberInput.ROUND_NONE);
		scale_z = new NumberInput("Z", 3, 3 , 90,  setValues, this, NumberInput.ROUND_DOWN);
		
		addEventListener(Event.ENTER_FRAME, getValues);
	}

	private function onChange()
	{
		getValues(null);
	}
	
	private function setValues() 
	{
		if ( !Selection.isHierarchyItem() )
			return;

		var transform:Transform = cast hostComponent;
		
		transform.x = location_x.value;
		transform.y = location_y.value;
		transform.z = location_z.value;
		
		transform.rotationX = rotation_x.value ;
		transform.rotationY = rotation_y.value ;
		transform.rotationZ = rotation_z.value ;
		
		transform.scaleX = scale_x.value;
		transform.scaleY = scale_y.value;
		transform.scaleZ = scale_z.value;
	}
	private function getValues(_) 
	{
		if ( !Selection.isHierarchyItem() || hostComponent==null)
			return;
		
		var transform:Transform = cast hostComponent;
		
		location_x.value =  transform.x;
		location_y.value =  transform.y;
		location_z.value =  transform.z;
		
		rotation_x.value =  transform.rotationX ;
		rotation_y.value =  transform.rotationY ;
		rotation_z.value =  transform.rotationZ ;
		
		scale_x.value =  transform.scaleX;
		scale_y.value =  transform.scaleY;
		scale_z.value =  transform.scaleZ;
	}
	override public function resize()
	{
		if ( !Selection.isHierarchyItem() )
			return;
		
		super.resize();
		hostComponent = Selection.GetSelectedEntity().getChild(Transform);
		getValues(null);
		
	}
	
}