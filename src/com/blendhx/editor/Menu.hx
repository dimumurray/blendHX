package com.blendhx.editor;
import com.blendhx.editor.spaces.Space;

import com.blendhx.core.components.*;
import com.blendhx.editor.panels.*;
import flash.Lib;
import com.blendhx.editor.uicomponents.*;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;
/*


 */
class Menu extends HorizontalPanel
{

	private var components:Array<String>;
	public function new() 
	{
		super();
		components = ["Mesh Renderer", "Camera", "RigidBody", "Lamp", "Collidor", "Audio"];
		createMenu();
		//if(NativeWindow.supportsMenu)
			//Lib.current.stage.nativeWindow.menu = createRootMenu();
	}
	private function doNothing() {}
	private function createMenu()
	{
		new MenuButton("File", 3,  doNothing, this);
		new MenuButton("Help",  3,  doNothing, this).x;
	}
	
	override public function resize()
	{
		var _x:Float = 5;
		for (element in elements)
		{
			element.x = _x;
			_x += element._width + 5;
		}
	}

	private function createRootMenu():NativeMenu
	{
		var menu:NativeMenu = new NativeMenu();
		
		var fileMenu:NativeMenu = new NativeMenu();
		var command:NativeMenuItem = fileMenu.addItem(new NativeMenuItem("New Project"));
		command.data = "New Project";
		command.addEventListener(Event.SELECT, newProject);
		
		var entityMenu:NativeMenu = new NativeMenu();
		
		command = entityMenu.addItem( new NativeMenuItem("New" ));
		command.data = "new entity";
		
		
		command = entityMenu.addItem( new NativeMenuItem("Delete Selected" ));
		command.data = "delete entity";

		
		entityMenu.addItem( new NativeMenuItem("", true) );
		entityMenu.addItem( new NativeMenuItem("Add Component") ).enabled = false;
		
		for(component in components)
		{
			command = entityMenu.addItem( new NativeMenuItem(component) );
			command.data = component;
			//command.addEventListener(Event.SELECT, addComponent);
		}
		
		menu.addSubmenu(fileMenu ,"File");
		menu.addSubmenu(entityMenu ,"Entity");
		return menu;
	}

	
	private function newProject(_)
	{
		
	}



}