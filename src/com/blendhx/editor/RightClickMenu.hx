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
	private static var fileItemMenu:NativeMenu;
	private static var assetsPanelCreateMenu:NativeMenu;
	private static var gameObjectMenu:NativeMenu;
	
	//the gameobject in the heirarchy which is righ clicked
	private static var richClickedHierarchyItem:HierarchyItem;
	
	public static function FileItem(fileItem:FileItem)
	{
		if( fileItemMenu == null )
		{
			fileItemMenu = new NativeMenu();
			fileItemMenu.addItem( new NativeMenuItem("Open" )).addEventListener(Event.SELECT, openFile.bind(fileItem) );
			fileItemMenu.addItem( new NativeMenuItem("Rename" )).addEventListener(Event.SELECT, renameFile.bind(fileItem) );
			fileItemMenu.addItem( new NativeMenuItem("Delete")).addEventListener(Event.SELECT, deleteSelectedFile.bind(fileItem) );
		}
		
		fileItemMenu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	public static function AssetsPanelCreateMenu()
	{
		if( assetsPanelCreateMenu == null)
		{
			assetsPanelCreateMenu = new NativeMenu();
			assetsPanelCreateMenu.addItem( new NativeMenuItem("New Folder" )).addEventListener(Event.SELECT, newFolder);
			assetsPanelCreateMenu.addItem( new NativeMenuItem("Material")).addEventListener(Event.SELECT, newMaterial);
			assetsPanelCreateMenu.addItem( new NativeMenuItem("Shader")).addEventListener(Event.SELECT, newShader);
			assetsPanelCreateMenu.addItem( new NativeMenuItem("Haxe Component")).addEventListener(Event.SELECT, newScript);
			assetsPanelCreateMenu.addItem( new NativeMenuItem("ActionScript Component")).enabled = false;
		}
			
		assetsPanelCreateMenu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	public static function GameObjectMenu(hierarchyItem:HierarchyItem)
	{
		
		richClickedHierarchyItem = hierarchyItem;
		
		if(gameObjectMenu == null)
		{
			var selectedGameObject:GameObject = hierarchyItem.gameobject;
			
			gameObjectMenu = new NativeMenu();
			gameObjectMenu.addItem( new NativeMenuItem("New" )).addEventListener(Event.SELECT, createGameObject);
			gameObjectMenu.addItem( new NativeMenuItem("Rename" )).addEventListener(Event.SELECT, renameGameObject);
			gameObjectMenu.addItem( new NativeMenuItem("Delete Selected")).addEventListener(Event.SELECT, removeSelectedGameObject);
			gameObjectMenu.addItem( new NativeMenuItem("", true) );
			gameObjectMenu.addItem( new NativeMenuItem("Add Component") ).enabled = false;
			gameObjectMenu.addItem( new NativeMenuItem("", true) );
			
			for(component in components)
			{
				var item:NativeMenuItem = gameObjectMenu.addItem( new NativeMenuItem(component) );

				item.addEventListener(Event.SELECT, addComponent.bind(component));
				if(component != "Camera" && component != "Mesh Renderer")
					item.enabled = false;
			}
		}
	
		gameObjectMenu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
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
	
	private static function createGameObject(_) 
	{
		var gameObject:GameObject = richClickedHierarchyItem.gameobject;
		gameObject.addChild( new GameObject() );
		HierarchyPanel.getInstance().populate();
	}
	private static function renameGameObject(_) 
	{
		HierarchyPanel.getInstance().renameGameObject( richClickedHierarchyItem );
	}

	private static function removeSelectedGameObject(_) 
	{
		var gameObject:GameObject = richClickedHierarchyItem.gameobject;
		gameObject.parent.removeChild(gameObject);
		gameObject.destroy();
		HierarchyPanel.getInstance().populate();
	}
	
	
	private static function addComponent(componentName:String, _)
	{
		var gameObject:GameObject = richClickedHierarchyItem.gameobject;
		
		var component:Component = null;
			
		switch (componentName)
		{
			case "Camera":
				component = new Camera();
			case "Mesh Renderer":
				component = new MeshRenderer();
			default:
				return;
		}
		
		gameObject.addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
	}

}