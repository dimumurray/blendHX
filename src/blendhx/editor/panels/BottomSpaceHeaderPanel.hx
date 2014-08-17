package blendhx.editor.panels;
import blendhx.editor.data.IO;
import openfl.net.FileFilter;

import openfl.display.Graphics;
import openfl.filesystem.File;
import openfl.Lib;
import openfl.desktop.NativeApplication;
import openfl.display.NativeWindow;
import openfl.display.NativeMenu;
import openfl.display.NativeMenuItem;
import openfl.events.Event;

import blendhx.editor.RightClickMenu;
import blendhx.editor.uicomponents.UIElement;
import blendhx.editor.spaces.Space;
import blendhx.core.components.*;
import blendhx.editor.panels.*;
import blendhx.editor.uicomponents.*;

/**

 * GPL

 */
class BottomSpaceHeaderPanel extends HorizontalPanel
{
	var toggleToConsoleButton:ImageButton;
	var toggleToAssetsButton:ImageButton;
	
	var createButton:MenuButton;
	var importButton:ImageButton;
	
	var clearConsoleButton:Button;
	
	public var switchSpaceCallback:Bool->Void;
	
	var showConsole:Bool = true;
	
	public function new() 
	{
		super();
		createMenu();
	}
	
	private function switchToAssetsPanel()
	{
		//are we alreay on Assets panel?
		if(showConsole == false)
			return;
		
		showConsole = !showConsole;
		
		if(switchSpaceCallback!=null)
			switchSpaceCallback(showConsole);
		
		addChild( createButton );
		addChild( importButton );
		removeChild( clearConsoleButton );
		
		
		toggleToConsoleButton.enabled = true;
		toggleToAssetsButton.drawBox(toggleToConsoleButton.click, null);
		toggleToConsoleButton.drawBox(toggleToConsoleButton.normal, null);
		toggleToAssetsButton.enabled = false;
	}
	
	private function switchToConsolePanel()
	{
		//are we alreay on Console panel?
		if(showConsole == true)
			return;
		
		showConsole = !showConsole;
		
		if(switchSpaceCallback!=null)
			switchSpaceCallback(showConsole);
		
		removeChild( createButton );
		removeChild( importButton );
		addChild( clearConsoleButton );
		
		toggleToAssetsButton.enabled = true;
		toggleToAssetsButton.drawBox(toggleToConsoleButton.normal, null);
		toggleToConsoleButton.drawBox(toggleToConsoleButton.click, null);
		toggleToConsoleButton.enabled = false;
	}
	
	private function createMenu()
	{
		createButton = new MenuButton("Create", 3,  openCreateMenu, this);
		importButton = new ImageButton(ImageButton.ADD, "Import", 1, 4, 3,  browseForImport, this);
		
		toggleToAssetsButton = new ImageButton(ImageButton.ASSETS_PANEL, "", 1, 9, 3,  switchToAssetsPanel, this, Button.ROUND_LEFT);
		toggleToConsoleButton = new ImageButton(ImageButton.CONSOLE_PANEL, "", 1, 9, 3,  switchToConsolePanel, this, Button.ROUND_RIGHT);
		clearConsoleButton = new Button("Clear", 1, 4, 3,  ConsolePanel.getInstance().clear , this);
		
		switchToAssetsPanel();
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
			 
		toggleToConsoleButton.x = _width - toggleToConsoleButton._width - 5;
		toggleToAssetsButton.x = toggleToConsoleButton.x - toggleToAssetsButton._width - 10;
		clearConsoleButton.x = 5;
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
