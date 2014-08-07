package blendhx.editor.panels;

import blendhx.core.assets.*;
import blendhx.core.components.MeshRenderer;
import blendhx.core.components.Entity;

import blendhx.editor.panels.*;
import blendhx.editor.spaces.Space;
import blendhx.editor.uicomponents.*;
import blendhx.core.components.*;
import blendhx.core.Scene;

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

		var saveObjects:Button = new Button("Save Objects", 1, 2, 35,  saveFile, this, Button.ROUND_LEFT);
		var loadObjects:Button = new Button("Load Objects", 2, 2, 35, startLoadingObjects, this, Button.ROUND_RIGHT);
		//var unsetObjects:Button = new Button("Unset Objects", 1, 2, 125, unset, this);
		//var initObjects:Button = new Button("Init Objects", 2, 2, 125, init, this);
	}	
	
	private function saveFile()
	{
		
		var bytes:ByteArray = new ByteArray();
		
		bytes.writeObject(Scene.getInstance().sceneObjects);
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
		/*urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		var bytes:ByteArray = urlLoader.data;
		var objects:Entity = bytes.readObject();
		Scene.getInstance().addChild(objects);
		Scene.getInstance().sceneObjects = objects;
		objects.init();
		HierarchyPanel.getInstance().populate();*/
	}
	
	function doCreateObjects():Void
	{

	}
}