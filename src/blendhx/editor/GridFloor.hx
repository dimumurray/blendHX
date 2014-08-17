package blendhx.editor;
import openfl.geom.Vector3D;
import openfl.system.ApplicationDomain;
import blendhx.core.assets.Assets;

import blendhx.core.components.Entity;
import blendhx.core.components.MeshRenderer;
import blendhx.core.shaders.WireFrameShader;
import blendhx.editor.GridFloorMesh;
import blendhx.core.assets.Material;
import blendhx.core.systems.RenderingSystem;


/**
* @author 
 */
class GridFloor extends Entity
{
	var gridRenderer:MeshRenderer;
	var gridFloorMesh:GridFloorMesh;
	var gridMaterial:Material;
	var gridShader:WireFrameShader;
	
	public function new() 
	{
		super();
		
		name = "Grid Floor";
		
		gridRenderer = new MeshRenderer();
		gridFloorMesh = new GridFloorMesh();
		gridMaterial = new Material("grid", "grid");
		gridShader = new WireFrameShader();
		gridShader.create(ApplicationDomain.currentDomain);
		
		gridShader.lineColor = new Vector3D(.28, .28, .28, 1);
		gridShader.lineWidth = new Vector3D(1 - 0.015, 0);
		gridMaterial.shader = gridShader;
		gridRenderer.material = gridMaterial;
		gridRenderer.mesh = gridFloorMesh;
		
		addChild(  gridRenderer );
		initilize();
	}
	
	override public function initilize():Void
	{
		gridMaterial.shader = gridShader;
		gridRenderer.material = gridMaterial;
		gridRenderer.mesh = gridFloorMesh;
		RenderingSystem.getInstance().registerMeshRenderer(gridRenderer);
	}
}
