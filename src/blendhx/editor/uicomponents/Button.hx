package blendhx.editor.uicomponents;

import blendhx.editor.panels.Panel;
import blendhx.core.*;

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
class Button extends UIElement
{
	private var label:SimpleTextField;
	private var normal:Array<UInt> = [0xa6a6a6, 0x8c8c8c];
	private var over:Array<UInt> = [0xb3b3b3, 0x9b9b9b];
	private var click:Array<UInt> = [0x565656, 0x6f6f6f];
	private var text:String;
	private var onClick:Void->Void;
	
	private var rounding:Array<Float>;
	public static var ROUND_LEFT:Array<Float> = [5, 0, 5 , 0];
	public static var ROUND_BOTH:Array<Float> = [5, 5, 5 , 5];
	public static var ROUND_RIGHT:Array<Float> = [0, 5, 0 , 5];
	public static var ROUND_NONE:Array<Float> = [0];
	
	public function new(text:String, slice:UInt, slices:UInt, _y:Float,  onClick:Void->Void, _panel:Panel, rounding:Array<Float> = null) 
	{
		super(slice, slices);
		
		y = _y;
		this.text = text;
		this.onClick = onClick;
		
		if(rounding == null)
			rounding = ROUND_BOTH;
		
		this.rounding = rounding;
		
		_panel.addUIElement(this);
		resize();
		drawBox(normal, null);
		drawText();

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
	
	private inline function drawText()
	{
		label = new SimpleTextField(TextFormatAlign.CENTER, text);
		label.width = _width;
		label.height = 20;

		addChild(label);
	}

	private inline function drawBox(state:Array<UInt>, _)
	{
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
		
		if(rounding == ROUND_BOTH)
			g.drawRoundRect(0, 0, _width, 20, 10);
		else if(rounding == ROUND_LEFT)
			g.drawRoundRectComplex(0, 0, _width + Panel.padding/2, 20, rounding[0], rounding[1], rounding[2], rounding[3]);
		else if(rounding == ROUND_RIGHT)
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
		
		removeChild(label);
		
		label = null;
		onClick = null;
		normal = null;
		over = null;
		click = null;
		rounding = null;
		
		super.destroy();
	}
}
