package com.blendhx.editor.panels;
import com.blendhx.editor.data.IO;
import flash.net.FileFilter;

import flash.display.Graphics;
import flash.filesystem.File;
import flash.Lib;
import flash.desktop.NativeApplication;
import flash.display.NativeWindow;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;

import com.blendhx.editor.RightClickMenu;
import com.blendhx.editor.uicomponents.UIElement;
import com.blendhx.editor.spaces.Space;
import com.blendhx.core.components.*;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.uicomponents.*;

/**

 * GPL

 */
class BottomSpaceHeaderPanel extends HorizontalPanel
{
	var toggleConsole:ImageButton;
	var toggleAssets:ImageButton;
	public function new() 
	{
		super();
		createMenu();
	}
	
	private function doNothing() {}
	
	private function createMenu()
	{
		new MenuButton("Create", 3,  openCreateMenu, this);
		new ImageButton(ImageButton.ADD, "Import", 1, 4, 3,  browseForImport, this);
		
		toggleAssets = new ImageButton(ImageButton.ASSETS_PANEL, "", 1, 9, 3,  doNothing, this, Button.ROUND_LEFT);
		toggleConsole = new ImageButton(ImageButton.CONSOLE_PANEL, "", 1, 9, 3,  doNothing, this, Button.ROUND_RIGHT);
	}
	
	private function browseForImport()
	{
		var allFilter = new FileFilter("All", "*.png;*.obj");
		var imagesFilter = new FileFilter("Images", "*.png");
 		var meshesFilter = new FileFilter("Meshs", "*.obj");
		
		var file:File = new File();
		file.addEventListener(Event.SELECT, importFile);
		file.browseForOpen("Import Mesh or Texture", [allFilter, imagesFilter, meshesFilter]);
	}
	
	private function importFile(e:Event)
	{
		var file:File = e.target;
		
		switch (file.extension)
		{
			case "png":
				IO.ImportPNG(file);
			case "obj":
				IO.ImportOBJ(file);
			default:
		}	
	}
	
	private function openCreateMenu()
	{
		RightClickMenu.AssetsPanelCreateMenu();
	}
	
	
	
	
	override public function resize()
	{
		var _x:Float = 5;
		for (element in elements)
		{
			element.x = _x;
			_x += element._width + 5;
		}
			 
		toggleConsole.x = _width - toggleConsole._width - 5;
		toggleAssets.drawBox(toggleConsole.click, null);
		toggleAssets.x = toggleConsole.x - toggleAssets._width - 10;
	}
			 
	override public function drawGraphics()
	{
		var g:Graphics = graphics;
		g.clear();
		g.beginFill( 0x727272 );
		g.drawRect(1, 1, _width-2, _height-1);
		g.endFill();
		
		g.lineStyle(1, 0x5b5b5b, .2);
		g.drawRect(1, 1, _width-2, _height-2);
		
	}
}