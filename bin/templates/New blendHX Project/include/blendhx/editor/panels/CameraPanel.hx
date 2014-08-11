package blendhx.editor.panels;

import blendhx.editor.Selection;
import blendhx.editor.uicomponents.*;
import blendhx.editor.spaces.Space;
import blendhx.core.components.Camera;
/**

 * GPL

 */
class CameraPanel extends Panel
{
	
	var fov_input:NumberInput;
	var near_input:NumberInput;
	var far_input:NumberInput;
	
	public function new() 
	{
		super("Camera", Space.SPACE_WIDTH, true);
		
		new Label("Field Of View:", 2, 2, 30, this);
		new Label("Clipping Planes:", 1, 2, 30, this);
		//new Label("Clipping", 1, 2, 80, this);

		fov_input = new NumberInput("fov", 2, 2, 50, applyValue, this, NumberInput.ROUND_BOTH);
		near_input = new NumberInput("near", 1, 2, 50, applyValue, this, NumberInput.ROUND_UP);
		far_input = new NumberInput("far", 1,2, 70, applyValue, this, NumberInput.ROUND_DOWN);
	}	
	
	private function applyValue() 
	{
		if ( !Selection.isHierarchyItem() || hostComponent == null)
			return;

		var camera:Camera = Selection.GetSelectedEntity().getChild(Camera);
		if (camera==null)
			return;
		
		camera.fov = fov_input.value;
		camera.near = near_input.value;
		camera.far = far_input.value;
		
		camera.resize();
	}
	private function updateValues() 
	{
		if ( !Selection.isHierarchyItem()  || hostComponent == null)
			return;

		var camera:Camera = Selection.GetSelectedEntity().getChild(Camera);
		if (camera==null)
			return;
		
		hostComponent = cast camera;
		
		fov_input.value =  camera.fov;
		near_input.value =  camera.near;
		far_input.value =  camera.far;
		
	}
	override public function resize()
	{
		super.resize();
		updateValues();
	}
}