package com.blendhx.core.components;

import com.blendhx.core.assets.*;
import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.editor.Debug;
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
	
	
	
	override public function setParent(_parent : GameObject)
	{
		super.setParent(_parent);
		init();
		register();
	}
	
	override public function init()
	{
		mesh = Assets.GetMesh( meshFileName );
		material = Assets.GetMaterial( materialFileName );
		
		if(mesh != null && material != null)
			material.init();
	}
	
	private function register()
	{
		transform = parent.getChild(Transform);
		
		RenderingSystem.getInstance().registerMeshRenderer(this);
	}
}