package blendhx.editor;
import flash.text.TextField;


import blendhx.editor.panels.ConsolePanel;

/**
* @author 
 */
class Debug
{

	static public function Log(object:Dynamic):Void
	{
		ConsolePanel.getInstance().log(object);
	}
	
}