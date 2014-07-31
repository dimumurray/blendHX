package com.blendhx.editor.panels;

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

		location_x = new NumberInput("X", 1, 3, 50, applyValue, this, NumberInput.ROUND_UP);
		location_y = new NumberInput("Y", 1, 3, 70, applyValue, this, NumberInput.ROUND_NONE);
		location_z = new NumberInput("Z", 1, 3, 90, applyValue, this, NumberInput.ROUND_DOWN);
		
		rotation_x = new NumberInput("X", 2, 3 , 50,  applyValue, this, NumberInput.ROUND_UP);
		rotation_y = new NumberInput("Y", 2, 3 , 70,  applyValue, this, NumberInput.ROUND_NONE);
		rotation_z = new NumberInput("Z", 2, 3 , 90,  applyValue, this, NumberInput.ROUND_DOWN);
		
		scale_x = new NumberInput("X", 3, 3 , 50,  applyValue, this, NumberInput.ROUND_UP);
		scale_y = new NumberInput("Y", 3, 3 , 70,  applyValue, this, NumberInput.ROUND_NONE);
		scale_z = new NumberInput("Z", 3, 3 , 90,  applyValue, this, NumberInput.ROUND_DOWN);
		
	}	

	private function doNothing() 
	{
	}
	private function applyValue() 
	{
		if ( !Selection.isHierarchyItem() )
			return;

		var m:Matrix3D = Selection.GetSelectedGameObject().getChild(Transform).matrix;
		m.position = new Vector3D(location_x.value, location_y.value, location_z.value);
	}
	private function updateValues() 
	{
		if ( !Selection.isHierarchyItem() )
			return;

		var transform:Transform = Selection.GetSelectedGameObject().getChild(Transform);
		hostComponent = transform;
		
		var m:Matrix3D = transform.matrix;

		location_x.setValue ( m.position.x );
		location_y.setValue ( m.position.y );
		location_z.setValue ( m.position.z );
	}
	override public function resize()
	{
		super.resize();
		updateValues();
	}
	
}