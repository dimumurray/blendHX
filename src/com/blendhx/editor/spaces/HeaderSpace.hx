package com.blendhx.editor.spaces;
import flash.display.Bitmap;
import com.blendhx.editor.assets.*;
import flash.Lib;
import com.blendhx.editor.uicomponents.Label;
import flash.display.Graphics;
import com.blendhx.editor.panels.Panel;
import com.blendhx.editor.Progressbar;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.panels.HorizontalPanel;
/**

 * GPL

 */
class HeaderSpace extends Space
{	
	var transofmrGizmosPanel:Panel;
	var playerControl:Panel;
	var menuBar:Panel;
	//var info:Panel;
	var progressBar:Progressbar;
    	
	public function new()
	{
		super();
		
		menuBar = new Menu();
		playerControl = new HorizontalPanel();
		transofmrGizmosPanel = new HorizontalPanel();
		//info = new HorizontalPanel();
		progressBar = Progressbar.getInstance();
		
		transofmrGizmosPanel._width = 100;
		playerControl._width = 70;
		//info._width = 95;
		
		new ImageButton(ImageButton.ROTATE, "", 1, 3, 3,  doNothing, transofmrGizmosPanel, Button.ROUND_LEFT);
		new ImageButton(ImageButton.TRANSFORM, "", 2, 3, 3,  doNothing, transofmrGizmosPanel, Button.ROUND_NONE);
		new ImageButton(ImageButton.SCALE, "", 3, 3, 3,  doNothing, transofmrGizmosPanel, Button.ROUND_RIGHT);
		
		new ImageButton(ImageButton.PLAY, "", 1, 2, 3,  doNothing, playerControl, Button.ROUND_LEFT);
		new ImageButton(ImageButton.REFRESH, "", 2, 2, 3,  doNothing, playerControl, Button.ROUND_RIGHT);
		
		//new Label("   v0.5 preview", 1, 1, 3, info);
		//new ImageButton(ImageButton.FULL_SCREEN, "", 4, 4, 3,  doNothing, info);
		//info.addChild( new Bitmap( new Images.AppIcon(0, 0) ) ).y = 4;
		
		addPanel(playerControl);
		addPanel(menuBar);
		addPanel(transofmrGizmosPanel);
		//addPanel(info);
		addChild(progressBar);
	}
	
	private function doNothing() {}
	// override to update component panels specific to this space
	override public function resize()
	{
		super.resize();
	}
	
	override public function resizePanels()
	{
		for (panel in panels)
		{
			panel.resize();
		}
	
		transofmrGizmosPanel._width = 100;
		transofmrGizmosPanel.x = Space.GetSpace(Space.HIERARCHY)._width + Space.GetSpace(Space.VIEWPORT)._width - transofmrGizmosPanel._width + Panel.padding;
		transofmrGizmosPanel.resize();
		
		playerControl._width = 70;
		playerControl.x = Space.GetSpace(Space.VIEWPORT)._width / 2 + Space.GetSpace(Space.VIEWPORT).x  - (transofmrGizmosPanel._width / 2) ;
		playerControl.resize();
		//progressBar.hide();
		progressBar.x = Lib.current.stage.stageWidth - progressBar._width + 2 - Panel.padding;
	
		//info.x = progressBar.x - info._width;
	}

	override public function drawGraphics()
	{
		var g:Graphics = graphics;
		g.clear();
		g.beginFill( 0x727272 );
		g.drawRect(0, 0, _width, _height);
		g.endFill();
		
		//g.lineStyle(1, 0x5b5b5b, .2);
		//g.drawRect(1, 1, _width-2, _height-2);
		
	}
}