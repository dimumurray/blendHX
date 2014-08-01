package com.blendhx.editor.spaces;


import com.blendhx.editor.panels.*;
import com.blendhx.core.*;
import flash.Lib;
import flash.geom.Rectangle;
import flash.accessibility.Accessibility;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;

/**
* @author 
 */
class Space extends Sprite
{
	//predefined hardcoded GetSpace
	//might not even need to make this dynamic for better fixed user experience
	public static var HIERARCHY:UInt = 0;
	public static var PROPERTIES:UInt = 1;
	public static var BOTTOM:UInt = 2;
	public static var VIEWPORT:UInt = 3;
	public static var CONSOLE:UInt = 4;
	public static var HEADER:UInt = 5;
	
	public static var SPACE_WIDTH:Float = 250;
	public static var SPACE_HEIGHT:Float = 170;
	public static var Spaces:Array<Space> = new Array<Space>();
	
	
	public var color:UInt = 0x727272;
	public var _width:Float=0;
	public var _height:Float=0;
	private var title:String;
	public var type:UInt;
	public var panels:Array<Panel>;
	
	//static function to resize all spaces. Each space then repositions it's panels
	public static function Resize()
	{
		for (space in Spaces)
		{
			if (space != null)
			{
				//put each defined type of space into it's position
				space.resize();
				//position the panels vertically in a row
				space.resizePanels();
			}
		}

	}
	//statc function to create an space or simply return the already created ones
	public static function GetSpace(spaceType:UInt):Space
	{
		var space:Space;
		//create sopace if isn't already
		if (Spaces[spaceType] == null)
		{
			// in the special case of a viewport, it should be created this way to allow setting Viewport special class variables
			switch (spaceType)
			{
				case Space.VIEWPORT:
					space = new ViewportSpace();
				case Space.PROPERTIES:
					space = new PropertiesSpace();
				case Space.HEADER:
					space = new HeaderSpace();
				case Space.BOTTOM:
					space = new BottomSpace();
				default:
					space = new Space();
			}
			
			space.type = spaceType;
			Spaces[spaceType] = space;
			
			Lib.current.stage.addChild(space);
		}
			
		return Spaces[spaceType];
	}
	
	public function new() 
	{
		super();
		
		panels = new Array<Panel>();
		drawGraphics();
		
		
	}
	

	//upon resizing the stage, Space static Resize methos calls each individual instance methods as follows
	// this method should be rewritten to account other spaces custom dimensions
	public function resize()
	{
		var stageWidth:Float = stage.stageWidth;
		var stageHeight:Float = stage.stageHeight;
		
		switch (type)
		{	
			case Space.HEADER:
				_width = stageWidth;
				_height = 26;
			case Space.HIERARCHY:
				y = Spaces[Space.HEADER]._height;
				x = -1;
				_width = 200 ;
				_height = stageHeight - Spaces[Space.BOTTOM]._height;
			case Space.PROPERTIES:
				_width = SPACE_WIDTH;
				_height = stageHeight - Spaces[Space.HEADER]._height;
				x = stageWidth - _width;
				y = Spaces[Space.HEADER]._height;
			case Space.BOTTOM:
				x = -1;
				_width = stageWidth - SPACE_WIDTH + 1;
				_height = SPACE_HEIGHT;
				y = stageHeight - _height;
			case Space.VIEWPORT:
				_width = stageWidth - Spaces[Space.HIERARCHY]._width - Spaces[Space.PROPERTIES]._width;
				_height = stageHeight - Spaces[Space.BOTTOM]._height - Spaces[Space.HEADER]._height;
				y = Spaces[Space.HEADER]._height;
				x = Spaces[Space.HIERARCHY]._width ;
			default:
				trace("No Space such as that exist in the application design. What are ou doing?");

		}
		//redraw background graphic accordingly
		drawGraphics();
	}

	//simple box behind the space
	public function drawGraphics()
	{
		var g:Graphics = graphics;
		g.clear();
		g.beginFill( color );
		g.lineStyle(1, 0x000000);
		g.drawRect(0, 0, _width, _height);
		g.endFill();
		
		g.lineStyle(1, 0xb8b8b8, .2);
		g.drawRect(1, 1, _width-2, _height-2);
		
	}
	
	//add the panel to panels variables, so later on we can reference to position them
	public function addPanel(panel:Panel)
	{
		addChild(panel);
		
		panels.push(panel);
		resizePanels();
	}

	public function removePanels()
	{
		for (panel in panels)
			removeChild(panel);
		
		panels = [];
	}
	
	//position the panels vertically in a row
	public function resizePanels()
	{
		if (panels.length >= 1)
		{
			panels[0].y= 0;
		}
			
		for (panel in panels)
		{
			panel._width = _width;
			panel.resize();
		}
		

		if (panels.length > 1)
		{
			for (i in 1...panels.length)
			{
				panels[i].y = panels[i-1]._height + panels[i-1].y;
			}
		}
	}
}