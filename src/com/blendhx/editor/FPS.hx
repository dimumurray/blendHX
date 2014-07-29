package com.blendhx.editor;

import com.blendhx.editor.uicomponents.*;
import com.blendhx.core.*;
import flash.text.TextFormatAlign;
import haxe.Timer;
import flash.events.Event;

class FPS extends SimpleTextField
{
	private var interval:Int;
	private var frameCounter:Int;
	private var timer:Timer;
	private var delta:Float;
		
	public function new()
	{
		super(TextFormatAlign.LEFT);
		
		frameCounter = 0;
		delta = 0;
		interval = 750;
		timer = new haxe.Timer(interval);
		timer.run = update;
		text = "00";
		
		this.addEventListener (Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function update():Void
	{
		var fps = frameCounter/(haxe.Timer.stamp() - delta);
		text = Std.string(fps).substr(0,2) + " fps";
		
		frameCounter = 0;
		delta = haxe.Timer.stamp();
	}
	
	public function onEnterFrame(e:Event) : Void
	{
		frameCounter++;    
	}
}
