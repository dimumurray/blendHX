package blendhx.core;

#if flash
import flash.system.System;
#end
			
import blendhx.editor.panels.HierarchyPanel;
import blendhx.editor.data.UserScripts;

import blendhx.core.systems.RenderingSystem;
import blendhx.core.components.*;
import blendhx.core.assets.*;

/**
 * GPL
 */
class Scene extends Entity
{
	public var editorObjects:Entity;
	public var sceneObjects:Entity = new Entity("Objects");
	public var playModeSceneObjects:Entity;
	
	private var editorCamera:Camera;
	public var gameCamera:Camera;
	public var activeCamera:Camera;
	
	
	private static var instance:Scene;
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
	
	override public function initilize():Void
    {
		createEditorObjects();
		gotoEditMode();
	}
	
	public function gotoEditMode()
	{
		activeCamera = editorCamera;
		addChild(sceneObjects);
		
		if(playModeSceneObjects!= null)
		{
			//removeChild(playModeSceneObjects);
			//playModeSceneObjects.destroy();
		}
			
		HierarchyPanel.getInstance().populate();
		#if flash
		System.pauseForGCIfCollectionImminent();
		#end
	}
	
	public function gotoPlayMode()
	{
		activeCamera = gameCamera;
		//removeChild(sceneObjects);
		//sceneObjects.uninitilize();
		playModeSceneObjects = sceneObjects;
		//playModeSceneObjects = cast sceneObjects.clone();
		//addChild(playModeSceneObjects);
		
		HierarchyPanel.getInstance().populate();
	}
	public function isEditMode():Bool
	{
		return activeCamera == editorCamera;
	}
	private function createEditorObjects()
	{
		var cameraGO:Entity;
		var camera:Camera;
    	var transform:Transform;
		
		editorObjects = new Entity("Editor");
		editorObjects.collapsedInEditor = true;
		
		cameraGO = new Entity("Editor Camera");
		camera = new Camera();
		cameraGO.addChild(camera);
    	transform = cameraGO.getChild(Transform);
    	transform.z = 6;
		
		addChild(editorObjects);
    	editorObjects.addChild(cameraGO);
		
		editorCamera = camera;
	}
	
	public function createDefaultSceneObjects()
	{
		//return;
		var house:Entity;
		var mesh:Mesh;
		var material:Material;
		var renderer:MeshRenderer;
		
		house = new Entity("house");
		renderer = new MeshRenderer();
		renderer.meshFileName = "meshes/house.obj";
		renderer.materialFileName = "materials/house.mat";
		house.addChild(  renderer );
		//var script:Component = UserScripts.GetComponent("scripts/RotateAroundY.hx");
		//house.addChild(  script );
		
		var cameraGO:Entity;
		var camera:Camera;
    	var transform:Transform;
		
		cameraGO = new Entity("Game Camera");
		camera = new Camera();
		camera.fov = 90;
		cameraGO.addChild(camera);
		transform = cameraGO.getChild(Transform);
    	transform.z = 6;
    	
		
		
		sceneObjects.addChild(cameraGO);
		sceneObjects.addChild(house);
	}
}