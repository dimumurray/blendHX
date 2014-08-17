package blendhx.editor.spaces;

import blendhx.editor.panels.Panel;
import blendhx.editor.panels.ConsolePanel;
import blendhx.editor.panels.*;
import blendhx.editor.uicomponents.*;
import blendhx.editor.panels.HorizontalPanel;
/**

 * GPL

 */
class BottomSpace extends Space
{	
	var header:BottomSpaceHeaderPanel;
	var assetsPanel:Panel;
	
	private var consolePanel:ConsolePanel;
	
	public function new()
	{
		super();
		
		header = new BottomSpaceHeaderPanel();
		header.switchSpaceCallback = this.switchSpaceCallback;
		
		consolePanel = ConsolePanel.getInstance();
		assetsPanel = AssetsPanel.getInstance();
		
		addPanel( header );
		addPanel( assetsPanel );
		color = 0x454545;
	}
	
	public function switchSpaceCallback( showConsole:Bool ):Void
	{
		if(showConsole)
		{
			removeChild(assetsPanel);
			addChild(consolePanel);
		}
		else
		{
			removeChild(consolePanel);
			addChild(assetsPanel);
			Space.Resize();
		}
	}
	private function doNothing() {}
	
	// override to update component panels specific to this space
	override public function resize()
	{
		super.resize();
		resizePanels();
	}
	
	override public function resizePanels()
	{
		for (panel in panels)
			panel.resize();

		assetsPanel._width = _width;
		assetsPanel.y = 26;
		assetsPanel._height = _height - 50;
		assetsPanel.drawGraphics();
		
		consolePanel._width = _width;
		consolePanel.y = 26;
		consolePanel._height = _height - 26;
		consolePanel.drawGraphics();
	
		header._height = 26;
		header._width = _width;
		header.drawGraphics();
	}
}
