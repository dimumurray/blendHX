package blendhx.editor;
import blendhx.editor.panels.AssetsPanel;

import blendhx.editor.panels.HierarchyPanel;
import blendhx.core.components.Entity;
import blendhx.core.Scene;
import blendhx.editor.spaces.Space;
import blendhx.core.assets.Assets;

import openfl.net.*;
import openfl.events.*;
import openfl.utils.ByteArray;
import openfl.filesystem.*;
import openfl.desktop.NativeApplication;
import openfl.data.EncryptedLocalStore;

/**

 * GPL

 */
class Project
{
	private static var _loadFile:FileReference;
	private static var urlLoader:URLLoader;
	public static var onProjectOpen:Void->Void;
	
	public static function loadProject(callBack:Void->Void)
	{
		onProjectOpen = callBack;
		var projectDirectory:File;
		var bytes:ByteArray = null;
		var projectDirectory:File;
		
		try
		{
			bytes = openfl.data.EncryptedLocalStore.getItem("projectDirectory");
		}
		catch(e:Dynamic)
		{
			EncryptedLocalStore.reset();
		}
		
		if(bytes!=null)
		{
			projectDirectory = new File().resolvePath( bytes.readObject() );
			if(!projectDirectory.exists)
				createNewProject();
			else
			{
				Assets.SetProjectDirectory( projectDirectory );
				AssetsPanel.getInstance().populate();
				
				onProjectOpen();
			}
		}
		else
		{
			
			createNewProject();
		}
		
		
	}
	
	private static function createNewProject()
	{
		Progressbar.getInstance().show(true, "Copying files");
		
		var projectDirectory:File;
		var bytes:ByteArray;
		
		projectDirectory = File.documentsDirectory.resolvePath("New blendHX Project");
		projectDirectory.createDirectory();
		bytes = new ByteArray();
		bytes.writeObject(projectDirectory.nativePath);
		bytes.position = 0;
		openfl.data.EncryptedLocalStore.setItem("projectDirectory", bytes);

		var newProjectTemplate:File = File.applicationDirectory.resolvePath("templates/New blendHX Project");
		newProjectTemplate.addEventListener(Event.COMPLETE, onNewProjectCopied);
		
		newProjectTemplate.copyToAsync (projectDirectory, true);
		Assets.SetProjectDirectory(projectDirectory);
		
	}
	private static function onNewProjectCopied(e:Event)
	{
		var file:File = e.target;
		file.removeEventListener(Event.COMPLETE, onNewProjectCopied);
		
		Progressbar.getInstance().hide();
		AssetsPanel.getInstance().populate();
		onProjectOpen();
	}
	
	public static function saveScene(_)
	{
		var objects = Scene.getInstance().sceneObjects;
		Scene.getInstance().removeChild(Scene.getInstance().sceneObjects);
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(objects);
		bytes.position = 0;
		
		
		var saveFile:File = Assets.casheDirectory.resolvePath("entities.bin");
		
		var stream = new FileStream();
		stream.open(saveFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		
		Scene.getInstance().addChild(objects);
		objects.initilize();
		bytes.clear();
		
		trace("Saved succesfully");
	}
	
	public static function loadScene()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		var urlRequest:URLRequest = new URLRequest(Assets.casheDirectory.resolvePath("entities.bin").nativePath ) ;
		urlLoader.load(urlRequest);
	}
	
	private static function onIOError(e:IOErrorEvent):Void
	{
		trace("entities.bin Not Found");
	}
	
	public static function browseForOpen(_):Void
	{
		var file:File = File.documentsDirectory;
		file.addEventListener(Event.SELECT, setNewProjectDirectory);
		file.browseForDirectory("Select a blendHX project directory");
	}
	public static function browseForNewProject(_):Void
	{
		var file:File = File.documentsDirectory;
		file.addEventListener(Event.SELECT, onBrowseForNewProject);
		file.browseForDirectory("Select an empty directory for a new blendHX project");
	}
	public static function onBrowseForNewProject(e:Event):Void
	{
		var file:File = e.target;
		file.removeEventListener(Event.SELECT, onBrowseForNewProject);
		
		if(file.getDirectoryListing().length > 0)
		{
			trace("Directory is not empty");
			return;
		}

		var newProjectTemplate:File = File.applicationDirectory.resolvePath("templates/New blendHX Project");
		newProjectTemplate.copyTo(file, true);
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(file.nativePath);
		bytes.position = 0;
		EncryptedLocalStore.setItem("projectDirectory", bytes);
		
		
		restartApplication();
	}
		
	public static function setNewProjectDirectory(e:Event):Void
	{
		var file:File = e.target;
		file.removeEventListener(Event.SELECT, setNewProjectDirectory);
		var casheDirectory:File = file.resolvePath("cashe");
		var sourceDirectory:File = file.resolvePath("source");
		
		if(casheDirectory.exists && sourceDirectory.exists)
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(file.nativePath);
			bytes.position = 0;
			EncryptedLocalStore.setItem("projectDirectory", bytes);
			
			restartApplication();
		}
		else
		{
			trace("Selected directory is not a blendHX project");
		}
		
	}
	
	public static function openProjectDirectory(_):Void
	{
		Assets.projectDirectory.openWithDefaultApplication();
	}
	
	private static function restartApplication()
	{
		NativeApplication.nativeApplication.exit();
		var restartBat:File = File.applicationDirectory.resolvePath("apps/restart.bat");
		restartBat.openWithDefaultApplication();
	}
	
	private static function loadCompleteHandler(event:Event)
	{
		urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		
		var objects = Scene.getInstance().sceneObjects;
		Scene.getInstance().removeChild(objects);
		objects.destroy();
		
		var bytes:ByteArray = new ByteArray();
		var bytes:ByteArray = urlLoader.data;
		
		var o:Entity = bytes.readObject();
		Scene.getInstance().sceneObjects = o;
		Scene.getInstance().addChild(Scene.getInstance().sceneObjects);
		o.initilize();
		HierarchyPanel.getInstance().populate();
	}
}
