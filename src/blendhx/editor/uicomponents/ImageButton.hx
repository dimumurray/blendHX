package blendhx.editor.uicomponents;
import openfl.display.BitmapData;

import blendhx.editor.panels.Panel;
import blendhx.core.*;
import blendhx.editor.assets.*;
import openfl.display.DisplayObjectContainer;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.display.GradientType;
import openfl.text.TextFormatAlign;
import openfl.text.TextFormat;
import openfl.display.Graphics;
import openfl.text.TextField;
import openfl.display.Sprite;

/**
* @author 
 */
class ImageButton extends UIElement
{
	public static var NEW_FOLDER:UInt = 0;
	public static var ADD:UInt = 1;
	public static var REMOVE:UInt = 2;
	public static var REFRESH:UInt = 3;
	public static var PLAY:UInt = 4;
	public static var ROTATE:UInt = 5;
	public static var TRANSFORM:UInt = 6;
	public static var SCALE:UInt = 7;
	public static var CONSOLE_PANEL:UInt = 8;
	public static var ASSETS_PANEL:UInt = 9;
	public static var FULL_SCREEN:UInt = 10;
	public static var STOP:UInt = 11;
	
	public static var Images:BitmapData = new Images.ButtonImages(0, 0);
	private var icon:Sprite;
	
	private var label:SimpleTextField;
	public var normal:Array<UInt> = [0xa6a6a6, 0x8c8c8c];
	private var over:Array<UInt> = [0xb3b3b3, 0x9b9b9b];
	public var click:Array<UInt> = [0x565656, 0x6f6f6f];

	private var text:String;
	private var onClick:Void->Void;
	
	private var rounding:Array<Float>;
	
	public function new(iconType:UInt, text:String, slice:UInt, slices:UInt, _y:Float,  onClick:Void->Void, panel:Panel, rounding:Array<Float> = null) 
	{
		super(slice, slices);
		
		y = _y;
		this.text = text;
		this.onClick = onClick;
		this.panel = panel;
		
		if(rounding == null)
			rounding = Button.ROUND_BOTH;
		
		this.rounding = rounding;
		
		panel.addUIElement(this);
		
		resize();
		drawBox(normal, null);
		drawText();
		drawIcon(iconType);

		addEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		addEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		addEventListener(MouseEvent.MOUSE_DOWN, drawBox.bind(click));
	}
	
	override public function resize()
	{
		x = getPositionX(slice, slices);
		_width = getWidth(slices);
	}
	
	private inline function drawIcon(type:UInt)
	{
		icon = new Sprite();
		
		var g:Graphics = icon.graphics;
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(0 ,  - (type * 16));
		g.beginBitmapFill(ImageButton.Images, matrix);
		g.drawRect(0,0, 16, 16);
		g.endFill();
		
		icon.x = 2;
		icon.y = 2;
		
		if(rounding == Button.ROUND_LEFT)
			icon.x = Panel.padding/2 + 1;
		else if(rounding == Button.ROUND_RIGHT)
			icon.x = Panel.padding/2 - 6;
		
		addChild(icon);
	}
	
	private  function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, text);
		label.width = _width-10;
		label.height = 20;
		label.x = 10;
		addChild(label);
	}

	public  function drawBox(state:Array<UInt>, _)
	{
		if(!enabled)
			return;
		
		if (state == click)
		{
			onClick();
		}

		var g:Graphics = graphics;
		var m:Matrix = new Matrix();
		
		g.clear();
		m.createGradientBox(_width*2, 20, 90);
		g.beginGradientFill(GradientType.LINEAR, state, [1, 1], [1, 255], m);
		g.lineStyle(1, 0x393939, 1, true);
		
		if(rounding == Button.ROUND_BOTH)
			g.drawRoundRect(0, 0, _width, 20, 10);
		else if(rounding == Button.ROUND_LEFT)
			g.drawRoundRectComplex(0, 0, _width + Panel.padding/2, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		else if(rounding == Button.ROUND_RIGHT)
			g.drawRoundRectComplex(-Panel.padding/2, 0, _width + Panel.padding/2, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		else
			g.drawRect(-Panel.padding/2, 0, _width + Panel.padding, 20);
			
		g.endFill();
	}
	
	override public function destroy()
	{
		removeEventListener(MouseEvent.MOUSE_OVER, drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_OUT, drawBox.bind(normal) );
		removeEventListener(MouseEvent.MOUSE_UP,drawBox.bind(over) );
		removeEventListener(MouseEvent.MOUSE_DOWN, drawBox.bind(click));
		
		removeChild(icon);
		removeChild(label);
		icon = null;
		label = null;
		onClick = null;
		rounding = null;
		normal = null;
		over = null;
		click = null;
		
		super.destroy();
	}
}
