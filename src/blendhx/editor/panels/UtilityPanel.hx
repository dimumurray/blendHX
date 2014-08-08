package blendhx.editor.panels;
import blendhx.core.components.Component;
import haxe.Unserializer;
import haxe.Serializer;
import blendhx.core.assets.Assets;

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
		super("Development Utility", Space.SPACE_WIDTH);

		var saveObjects:Button = new Button("Save Objects", 1, 2, 35,  saveFile, this, Button.ROUND_LEFT);
		var loadObjects:Button = new Button("Load Objects", 2, 2, 35, startLoadingObjects, this, Button.ROUND_RIGHT);
		new Button("action", 1, 1, 65, action, this, Button.ROUND_BOTH);
		//var unsetObjects:Button = new Button("Unset Objects", 1, 2, 125, unset, this);
	}	
	
	private function action()
	{
		var objects = Scene.getInstance().sceneObjects;
		Scene.getInstance().removeChild(Scene.getInstance().sceneObjects);
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(objects);
		objects.destroy();
		bytes.position = 0;
		var o:Entity = bytes.readObject();
		Scene.getInstance().sceneObjects = o;
		Scene.getInstance().addChild(Scene.getInstance().sceneObjects);
		o.initilize();
		HierarchyPanel.getInstance().populate();
	}
	private function saveFile()
	{
		trace(Scene.getInstance().sceneObjects.children);
		var objects = new Entity("fff");
		var bytes:ByteArray = new ByteArray();
		objects.uninitilize();
		bytes.writeObject(objects);
		bytes.position = 0;
		objects.initilize();
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
		var urlRequest:URLRequest = new URLRequest(Assets.casheDirectory.resolvePath("data.bin").nativePath ) ;
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
		var objects:Entity = bytes.readObject();
		Scene.getInstance().addChild(objects);
		//Scene.getInstance().sceneObjects = objects;
		objects.initilize();
		HierarchyPanel.getInstance().populate();
	}
	
	function doCreateObjects():Void
	{

	}
}