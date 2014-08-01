package com.blendhx.core;
import flash.geom.Vector3D;

import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.core.components.*;
import com.blendhx.core.assets.*;

/**
 * GPL
 */
class Scene extends GameObject
{
	private static var instance:Scene;
	
	public var editorObjects:GameObject;
	public var sceneObjects:GameObject;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new Scene();
      	else
          return instance;
  	}	
	
	public function new() 
	{
		super("Scene");
	}
	
	override public function init():Void
    {
		createEditorObjects();
	}
	
	private function createEditorObjects()
	{
		var cameraGO:GameObject;
		var camera:Camera;
    	var transform:Transform;
		
		editorObjects = new GameObject("Editor");
		cameraGO = new GameObject("Editor Camera");
		camera = new Camera();
    	transform = cameraGO.getChild(Transform);
    	transform.appendTranslation(0, -1, 6);
		
		
		
		addChild(editorObjects);
    	cameraGO.addChild(camera);
    	editorObjects.addChild(cameraGO);
		
		RenderingSystem.getInstance().camera = camera;
	}
	
	public function createDefaultSceneObjects()
	{
		var house:GameObject;
		var mesh:Mesh;
		var material:Material;
		var renderer:MeshRenderer;
		
		sceneObjects = new GameObject("Objects");
		
		house = new GameObject("house");
		renderer = new MeshRenderer();
		renderer.meshFileName = "meshes/house.obj";
		renderer.materialFileName = "materials/house.mat";
		house.addChild(  renderer );
		
		addChild(sceneObjects);
		sceneObjects.addChild(house);
	}
}