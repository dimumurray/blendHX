package blendhx.editor.spaces;
import blendhx.editor.panels.Panel;

import blendhx.editor.panels.*;
import blendhx.editor.uicomponents.*;
import blendhx.editor.panels.HorizontalPanel;
/**

 * GPL

 */
class BottomSpace extends Space
{	
	var transofmrGizmosPanel:Panel;
	var playerControl:Panel;
	var menuBar:Panel;
    
	var assetsPanel:Panel;
	
	public function new()
	{
		super();
		
		menuBar = new BottomSpaceHeaderPanel();

		
		assetsPanel = AssetsPanel.getInstance();
		addPanel(  menuBar );
		addPanel( assetsPanel );
		color = 0x454545;

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
	
		menuBar._height = 26;
		menuBar._width = _width;
		menuBar.drawGraphics();
	}
}