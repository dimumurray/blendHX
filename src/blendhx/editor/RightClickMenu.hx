package blendhx.editor;
import flash.net.URLRequest;
import blendhx.editor.panels.AssetsPanel;
import flash.errors.Error;
import blendhx.editor.spaces.Space;
import blendhx.core.components.Entity;

import flash.events.Event;
import flash.Lib;
import flash.filesystem.File;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;

import blendhx.core.components.*;
import blendhx.editor.panels.*;
import blendhx.editor.*;
import blendhx.editor.data.IO;

import blendhx.editor.Project;
/**

 * GPL

 */
class RightClickMenu
{
	
	private static var components:Array<String> = ["Mesh Renderer", "Camera", "RigidBody", "Collidor", "Lamp", "Audio"];
	private static var fileItemMenu:NativeMenu;
	private static var assetsPanelCreateMenu:NativeMenu;
	private static var entityMenu:NativeMenu;
	private static var helpMenu:NativeMenu;
	private static var fileMenu:NativeMenu;
	
	//the entity in the heirarchy which is righ clicked
	private static var richClickedHierarchyItem:HierarchyItem;
	private static var richClickedFileItem:FileItem;
	
	public static function openFileMenu()
	{
		if( fileMenu == null )
		{
			fileMenu = new NativeMenu();
			fileMenu.addItem( new NativeMenuItem("New project" )).addEventListener(Event.SELECT, Project.browseForNewProject );
			fileMenu.addItem( new NativeMenuItem("Open project" )).addEventListener(Event.SELECT, Project.browseForOpen );
			
			fileMenu.addItem( new NativeMenuItem("Save" )).addEventListener(Event.SELECT, Project.saveScene );
			fileMenu.addItem( new NativeMenuItem("", true) );
			fileMenu.addItem( new NativeMenuItem("Open project directory" )).addEventListener(Event.SELECT, Project.openProjectDirectory );
			fileMenu.addItem( new NativeMenuItem("", true) );
			fileMenu.addItem( new NativeMenuItem("Exit" )).addEventListener(Event.SELECT, exitApplication );
		}
		
		fileMenu.display(Lib.current.stage, 0, 26);
	}
	
	public static function openHelpMenu()
	{
		if( helpMenu == null )
		{
			helpMenu = new NativeMenu();
			helpMenu.addItem( new NativeMenuItem("open Github page" )).addEventListener(Event.SELECT, openGithubPage );
			helpMenu.addItem( new NativeMenuItem("", true) );
			helpMenu.addItem( new NativeMenuItem("blendHX v0.5 preview") ).enabled = false;
		}
		
		helpMenu.display(Lib.current.stage, 50, 26);
	}
	
	private static function exitApplication(_)
	{
		NativeApplication.nativeApplication.exit();
	}
	
	
	private static function openGithubPage(_)
	{
		var urlRequest:URLRequest = new URLRequest( "https://github.com/mehdadoo/blendhx" );
		Lib.getURL(urlRequest, "_blank");
	}

	public static function FileItem(fileItem:FileItem)
	{
		richClickedFileItem = fileItem;
		
		if( fileItemMenu == null )
		{
			fileItemMenu = new NativeMenu();
			fileItemMenu.addItem( new NativeMenuItem("Open" )).addEventListener(Event.SELECT, openFile );
			fileItemMenu.addItem( new NativeMenuItem("Rename" )).addEventListener(Event.SELECT, renameFile );
			fileItemMenu.addItem( new NativeMenuItem("Delete")).addEventListener(Event.SELECT, deleteSelectedFile );
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
			
		assetsPanelCreateMenu.display(Lib.current.stage, 0, Space.GetSpace(Space.BOTTOM).y + 26);
	}
	
	public static function EntityMenu(hierarchyItem:HierarchyItem)
	{
		
		richClickedHierarchyItem = hierarchyItem;
		
		if(entityMenu == null)
		{
			var selectedEntity:Entity = hierarchyItem.entity;
			
			entityMenu = new NativeMenu();
			entityMenu.addItem( new NativeMenuItem("New" )).addEventListener(Event.SELECT, createEntity);
			entityMenu.addItem( new NativeMenuItem("Rename" )).addEventListener(Event.SELECT, renameEntity);
			entityMenu.addItem( new NativeMenuItem("Delete Selected")).addEventListener(Event.SELECT, removeSelectedEntity);
			entityMenu.addItem( new NativeMenuItem("", true) );
			entityMenu.addItem( new NativeMenuItem("Add Component") ).enabled = false;
			entityMenu.addItem( new NativeMenuItem("", true) );
			
			for(component in components)
			{
				var item:NativeMenuItem = entityMenu.addItem( new NativeMenuItem(component) );

				item.addEventListener(Event.SELECT, addComponent.bind(component));
				if(component != "Camera" && component != "Mesh Renderer")
					item.enabled = false;
			}
		}
	
		entityMenu.display(Lib.current.stage, Lib.current.stage.mouseX, Lib.current.stage.mouseY);
	}
	
	private static function deleteSelectedFile( _ )
	{
		var fileItem:FileItem = richClickedFileItem;
		var file:File = AssetsPanel.currentDirectory.resolvePath( fileItem.fileName );
			
		if(file.isDirectory)
		{
			try{
				file.deleteDirectory(false);
				AssetsPanel.getInstance().populate();
			}
			catch(e:Error){trace(e.message);}
		}
		else
			IO.DeleteFile(file);
	}
	
	private static function openFile( _ )
	{
		var fileItem:FileItem = richClickedFileItem;
		fileItem.onClick(fileItem);
	}
	private static function renameFile( _ )
	{
		var fileItem:FileItem = richClickedFileItem;
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
	
	private static function createEntity(_) 
	{
		var entity:Entity = richClickedHierarchyItem.entity;
		entity.addChild( new Entity() );
		HierarchyPanel.getInstance().populate();
	}
	private static function renameEntity(_) 
	{
		HierarchyPanel.getInstance().renameEntity( richClickedHierarchyItem );
	}

	private static function removeSelectedEntity(_) 
	{
		var entity:Entity = richClickedHierarchyItem.entity;
		if(entity.name == "Editor Camera" || entity.name == "Editor" || entity.name == "Objects" || entity.name == "Scene")
			return;
		entity.parent.removeChild(entity);
		entity.destroy();
		HierarchyPanel.getInstance().populate();
	}
	
	
	private static function addComponent(componentName:String, _)
	{
		var entity:Entity = richClickedHierarchyItem.entity;
		
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
		
		entity.addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
	}

}