package blendhx.core.components;

import blendhx.core.assets.Assets;
import blendhx.core.assets.Material;
import blendhx.core.assets.Mesh;
import blendhx.core.systems.RenderingSystem;

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
		name = "MeshRenderer";
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
