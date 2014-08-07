package blendhx.core;
import flash.system.System;
import flash.utils.ByteArray;
import blendhx.editor.panels.HierarchyPanel;
import blendhx.editor.data.UserScripts;
import flash.geom.Vector3D;

import blendhx.core.systems.RenderingSystem;
import blendhx.core.components.*;
import blendhx.core.assets.*;

/**
 * GPL
 */
class Scene extends Entity
{
	private static var instance:Scene;
	
	public var editorObjects:Entity;
	public var sceneObjects:Entity = new Entity("Objects");
	private var editorCamera:Camera;
	public var gameCamera:Camera;
	public var activeCamera:Camera;
	
	public var playModeSceneObjects:Entity;
	
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
		
		System.pauseForGCIfCollectionImminent();
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
    	//transform.appendTranslation(0, -1, 6);
		
		addChild(editorObjects);
    	editorObjects.addChild(cameraGO);
		
		editorCamera = camera;
	}
	
	public function createDefaultSceneObjects()
	{
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
		gameCamera = camera;
		transform = cameraGO.getChild(Transform);
    	//transform.appendTranslation(0, -1, 6);
    	
		
		
		sceneObjects.addChild(cameraGO);
		sceneObjects.addChild(house);
	}
}