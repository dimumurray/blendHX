package com.blendhx.editor.panels;

import com.blendhx.editor.assets.*;
import com.blendhx.editor.Selection;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.spaces.Space;
import com.blendhx.core.components.MeshRenderer;
import hxsl.Shader;

/**

 * GPL

 */
class MeshRendererPanel extends Panel
{
	var mesh_input:ObjectInput;
	var material_input:ObjectInput;
	
	
	public function new() 
	{
		super("MeshRenderer", Space.SPACE_WIDTH, true);
		
		new Label("Mesh:", 1, 1, 30, this);
		mesh_input = new ObjectInput(FileType.MESH, 1, 1,50, doNothing, this);
		
		new Label("Material:", 1, 1, 70, this);
		material_input = new ObjectInput(FileType.MATERIAL, 1, 1,90, doNothing, this);
		
		
		new Button("Reload Renderer", 1, 1, 120,  applyValue, this);
	}
	
	public function doNothing()
	{
	}
	
	private function applyValue() 
	{
		if ( !Selection.isHierarchyItem() )
			return;

		var renderer:MeshRenderer = Selection.GetSelectedGameObject().getChild(MeshRenderer);
		if (renderer==null)
			return;
		
		renderer.meshFileName = mesh_input.value;
		renderer.materialFileName = material_input.value;
		renderer.init();
	}
	
	
	private function updateValues() 
	{
		if ( !Selection.isHierarchyItem() )
			return;

		var renderer:MeshRenderer = Selection.GetSelectedGameObject().getChild(MeshRenderer);
		if (renderer==null)
			return;
		
		hostComponent = renderer;
		
		mesh_input.setValue ( renderer.meshFileName );
		material_input.setValue ( renderer.materialFileName );
	}
	
	override public function resize()
	{
		super.resize();
		updateValues();
	}
}