package blendhx.editor;
import blendhx.editor.spaces.Space;

import blendhx.core.components.*;
import blendhx.editor.panels.*;
import openfl.Lib;
import blendhx.editor.uicomponents.*;
import openfl.desktop.NativeApplication;
import openfl.display.NativeWindow;
import openfl.display.NativeMenu;
import openfl.display.NativeMenuItem;
import openfl.events.Event;
/*


 */
class Menu extends HorizontalPanel
{
	public function new() 
	{
		super();
		createMenu();
	}
	
	private function createMenu()
	{
		new MenuButton("File", 3,  RightClickMenu.openFileMenu, this);
		new MenuButton("Help",  3,  RightClickMenu.openHelpMenu, this);
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

}
