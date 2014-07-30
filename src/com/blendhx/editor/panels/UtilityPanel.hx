package com.blendhx.editor.panels;

import com.blendhx.core.assets.*;
import com.blendhx.core.components.MeshRenderer;
import com.blendhx.core.components.GameObject;

import com.blendhx.editor.panels.*;
import com.blendhx.editor.spaces.Space;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.core.components.*;
import com.blendhx.core.Scene;

import flash.net.FileFilter;
import flash.net.URLRequest;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.net.FileReference;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.errors.Error;
import flash.utils.ByteArray;

/**

 * GPL

 */
class UtilityPanel extends Panel
{
	private var _loadFile:FileReference;
	private var urlLoader:URLLoader;
	
	public function new() 
	{
		super("Utility", Space.SPACE_WIDTH);

		var createObjects:Button = new Button("Create Objects", 1, 3, 35, doCreateObjects, this, Button.ROUND_LEFT);
		var saveObjects:Button = new Button("Save Objects", 2, 3, 35,  saveFile, this, Button.ROUND_NONE);
		var loadObjects:Button = new Button("Load Objects", 3,3, 35, startLoadingObjects, this, Button.ROUND_RIGHT);
		//var unsetObjects:Button = new Button("Unset Objects", 1, 2, 125, unset, this);
		//var initObjects:Button = new Button("Init Objects", 2, 2, 125, init, this);
		var traceObjects:Button = new Button("Update Hierarchy", 1, 1, 65, populateHierarchyPanel, this);
	}	
	
	private function saveFile()
	{
		
		var bytes:ByteArray = new ByteArray();
		
		bytes.writeObject(Scene.getInstance().objects);
		bytes.position = 0;

		var saveFile:FileReference = new FileReference();
		saveFile.addEventListener(Event.COMPLETE, saveCompleteHandler);
		saveFile.save(bytes, "data.bin");
	}
	
	private function startLoadingObjects()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		var urlRequest:URLRequest = new URLRequest("data.bin");
		urlLoader.load(urlRequest);
	}
	
	private function onIOError(e:IOErrorEvent):Void
	{
		Debug.Log("data.bin Not Found");
	}
	
	private function saveCompleteHandler(e:Event)
	{
		Debug.Log("saved");
	}

	private function loadCompleteHandler(event:Event)
	{
		urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		var bytes:ByteArray = urlLoader.data;
		var objects:GameObject = bytes.readObject();
		Scene.getInstance().addChild(objects);
		Scene.getInstance().objects = objects;
		objects.init();
		populateHierarchyPanel();
	}
	
	function doCreateObjects():Void
	{
		var objects:GameObject = new GameObject("Objects");
		
		var g:GameObject;
		var mesh:Mesh;
		var material:Material;
		var renderer:MeshRenderer;
		
		g = new GameObject("house");
		renderer = new MeshRenderer();
		renderer.meshFileName = "meshes/house.obj";
		renderer.materialFileName = "materials/head.mat";
		g.addChild(  renderer );
		
		objects.addChild(g);
		
		
		Scene.getInstance().addChild(objects);
		Scene.getInstance().objects = objects;
		populateHierarchyPanel();
	}

	
	private function populateHierarchyPanel()
	{
		hierarchyPanel = HierarchyPanel.getInstance();
		hierarchyPanel.populate();
	}
	
	var hierarchyPanel:HierarchyPanel;	
}