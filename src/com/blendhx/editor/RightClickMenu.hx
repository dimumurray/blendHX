package com.blendhx.editor;
import com.blendhx.editor.panels.AssetsPanel;
import flash.errors.Error;
import com.blendhx.editor.spaces.Space;
import com.blendhx.core.components.GameObject;

import flash.events.Event;
import flash.Lib;
import flash.filesystem.File;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;

import com.blendhx.core.components.*;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.*;
import com.blendhx.editor.data.IO;
/**

 * GPL

 */
class RightClickMenu
{
	
	private static var components:Array<String> = ["Mesh Renderer", "Camera", "RigidBody", "Collidor", "Lamp", "Audio"];
	
	public function new() 
	{
		
	}
	
	public static function FileItem(fileItem:FileItem)
	{
		var menu:NativeMenu = new NativeMenu();
		
		menu.addItem( new NativeMenuItem("Open" )).addEventListener(Event.SELECT, openFile.bind(fileItem) );
		menu.addItem( new NativeMenuItem("Rename" )).addEventListener(Event.SELECT, renameFile.bind(fileItem) );
		menu.addItem( new NativeMenuItem("Delete")).addEventListener(Event.SELECT, deleteSelectedFile.bind(fileItem) );
		
		menu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	public static function AssetsPanelCreateMenu()
	{
		var menu:NativeMenu = new NativeMenu();
		
		menu.addItem( new NativeMenuItem("New Folder" )).addEventListener(Event.SELECT, newFolder);
		menu.addItem( new NativeMenuItem("Material")).addEventListener(Event.SELECT, newMaterial);
		menu.addItem( new NativeMenuItem("Shader")).addEventListener(Event.SELECT, newShader);
		menu.addItem( new NativeMenuItem("Haxe Component")).addEventListener(Event.SELECT, newScript);
		menu.addItem( new NativeMenuItem("ActionScript Component")).enabled = false;
		
		menu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	public static function GameObjectMenu(gameObject:GameObject)
	{
		var menu:NativeMenu = new NativeMenu();
		
		menu.addItem( new NativeMenuItem("New" )).addEventListener(Event.SELECT, createGameObject.bind(gameObject));
		menu.addItem( new NativeMenuItem("Delete Selected")).addEventListener(Event.SELECT, removeSelectedGameObject.bind(gameObject));
		
		menu.addItem( new NativeMenuItem("", true) );
		menu.addItem( new NativeMenuItem("Add Component") ).enabled = false;
		menu.addItem( new NativeMenuItem("", true) );
		
		for(component in components)
		{
			var item:NativeMenuItem = menu.addItem( new NativeMenuItem(component) );
		
			item.addEventListener(Event.SELECT, addComponent.bind(component, gameObject));
			if(component != "Camera" && component != "Mesh Renderer")
				item.enabled = false;
		}
	
	
		menu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	private static function deleteSelectedFile( fileItem:FileItem, _ )
	{
		var file:File = AssetsPanel.currentDirectory.resolvePath( fileItem.fileName );
		//file.addEventListener();
			
		if(file.isDirectory)
		{
			try{
				file.deleteDirectory(false);
				AssetsPanel.getInstance().populate();
			}
			catch(e:Error){Debug.Log(e.message);}
		}
		else
			IO.DeleteFile(file);
	}
	
	private static function openFile( fileItem:FileItem, _ )
	{
		fileItem.onClick(fileItem);
	}
	private static function renameFile( fileItem:FileItem, _ )
	{
		AssetsPanel.getInstance().renameFile(fileItem);
	}
	
	private static function newFolder(_)
	{
		IO.NewFolder();
	}
	private static function newMaterial(_)
	{
		IO.NewMaterial();
	}

	private static function newShader(_)
	{
		IO.NewShader();
	}
	private static function newScript(_)
	{
		IO.NewScript();
	}
	
	private static function createGameObject(gameObject:GameObject, _) 
	{
		gameObject.addChild( new GameObject() );
		HierarchyPanel.getInstance().populate();
	}
	private static function removeSelectedGameObject(gameObject:GameObject, _) 
	{
		gameObject.parent.removeChild(gameObject);
		gameObject.destroy();
		HierarchyPanel.getInstance().populate();
	}
	
	
	private static function addComponent(componentName:String, gameObject:GameObject, _)
	{
		var component:Component;
			
		switch (componentName)
		{
			case "Camera":
				component = new Camera();
			case "Mesh Renderer":
				component = new MeshRenderer();
			default:
				component = new Camera();
		}
    	
    	gameObject.addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
	}

}