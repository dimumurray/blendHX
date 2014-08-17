package blendhx.core;
import openfl.utils.ByteArray;

#if flash
import openfl.system.System;
#end

import blendhx.editor.GridFloor;
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
	
	public var editorCamera:Camera;
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
		
		editorObjects.initilize();
		activeCamera = editorCamera;
		
		addChild(sceneObjects);
		sceneObjects.initilize();
		
		if(playModeSceneObjects!= null)
		{
			removeChild(playModeSceneObjects);
			playModeSceneObjects.uninitilize;
			playModeSceneObjects.destroy();
			playModeSceneObjects = null;
		}
			
		HierarchyPanel.getInstance().populate();
		#if flash
		System.pauseForGCIfCollectionImminent();
		#end
	}
	
	public function gotoPlayMode()
	{
		editorObjects.uninitilize();
		
		removeChild(sceneObjects);
		sceneObjects.uninitilize();
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject( sceneObjects );
		bytes.position = 0;
		playModeSceneObjects = bytes.readObject();
		addChild(playModeSceneObjects);
		playModeSceneObjects.initilize();
		
		activeCamera = gameCamera;
		
		bytes = null;
		
		HierarchyPanel.getInstance().populate();
	}
	public function isEditMode():Bool
	{
		return activeCamera == editorCamera;
	}
	private function createEditorObjects()
	{
		var cameraEntity:Entity;
		var camera:Camera;
    	var transform:Transform;
		var gridEntity:GridFloor;
		
		editorObjects = new Entity("Editor");
		editorObjects.collapsedInEditor = true;
		
			
		cameraEntity = new Entity("Editor Camera");
		camera = new Camera();
		cameraEntity.addChild(camera);
    	transform = cameraEntity.getChild(Transform);
    	transform.z = 7;
		transform.rotationX = 330;
		transform.rotationY = 30;
		transform.rotationZ = 340;
		
		cameraEntity.addChild( new blendhx.editor.scripts.EditorCameraController() );
		
		gridEntity = new GridFloor();
		
		
    	editorObjects.addChild(cameraEntity);
		editorObjects.addChild(gridEntity);
		
		
		editorCamera = camera;
	}
	
	public function createDefaultSceneObjects()
	{
		return;
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
