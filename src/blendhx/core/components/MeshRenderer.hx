package blendhx.core.components;

import blendhx.core.assets.*;
import blendhx.core.systems.RenderingSystem;
import blendhx.editor.Debug;
import flash.display3D.Context3DCompareMode;
import shaders.*;
import flash.display3D.Context3D;
import hxsl.Shader;
/**
* @author 
 */
class MeshRenderer extends Component
{
	public var material:Material;
	public var mesh:Mesh;
	
	public var materialFileName:String="";
	public var meshFileName:String="";
	
	public function new()
	{
		name = "Transform";
	}
	
	override public function initilize()
	{
		mesh = Assets.GetMesh( meshFileName );
		material = Assets.GetMaterial( materialFileName );
		
		if(mesh != null && material != null)
			material.init();
		
		RenderingSystem.getInstance().registerMeshRenderer(this);
	}
	
	override public function clone():Dynamic
	{
		var copy:MeshRenderer = new MeshRenderer();
		copy.enabled = enabled;
		copy.name = name;
		copy.materialFileName = materialFileName;
		copy.meshFileName = meshFileName;
		
		return copy;
	}
	
	override public function uninitilize()
	{
		material = null;
		mesh = null;
		
		RenderingSystem.getInstance().unregisterMeshRenderer(this);
	}
	
	override public function destroy()
	{
		super.destroy();
		material = null;
		mesh = null;
		
	}
}