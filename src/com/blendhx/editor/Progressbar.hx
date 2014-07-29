package com.blendhx.editor;
import com.blendhx.editor.spaces.Space;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextFormatAlign;
import com.blendhx.editor.uicomponents.SimpleTextField;

import flash.display.*;
import com.blendhx.editor.assets.*;

/**

 * GPL

 */
class Progressbar extends Sprite
{
	private static var instance:Progressbar;
	
	private var graphic:Sprite;
	public var percent:Float = 0;
	public var isEndLess:Bool;
	private var label:SimpleTextField;
	public var _width:Float = 0;
	private var progressGraphic:Sprite;
	
	public var totalJobs:Int = 0;
	public var jobsDone:Int = 0;
	
	public var onFinish:Void->Void;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new Progressbar();
      	else
          return instance;
  	}	
	
	public function new() 
	{
		super();
		initGraphic();
	}
	
	public function initGraphic() 
	{
		label = new SimpleTextField(TextFormatAlign.LEFT, "Encoding ATF");
		label.width = 100;
		
		graphic = new Sprite();
		graphic.addChild( new Bitmap( new Images.Progressbar(0, 0) ) ).y = 18;
		graphic.addChild(label);
		
		progressGraphic = new Sprite();
		graphic.addChild(progressGraphic);
	}
	
	public function hide() 
	{
		if(_width!= 0)
		{
			_width = 0;
			removeChild(graphic);
			removeEventListener( Event.ENTER_FRAME, update);
		}
			
		Space.Resize();
	}
	
	public function update( _ ) 
	{
		var g:Graphics = progressGraphic.graphics;
		g.clear();
		g.beginFill(0x444444);
		
		
		
		if(isEndLess)
		{
			percent += 1;
			if(percent>200)
				percent =0;
			
			var start:Float = 1;
			var end:Float = 100;
			if (percent < 100)
			{
				start = 1;
				end = percent;
			}
				
			else
			{
				start = 100 ;
				end = percent - 200;
			}
				
			
			g.drawRect(start, 19, end, 2);
		}
		else
		{
			if(jobsDone == totalJobs)
			{
				if(onFinish != null )onFinish();
				hide();
				return;
			}
			percent = jobsDone * 100 / totalJobs;
			g.drawRect(1, 19, percent, 2);
		}
		g.endFill();
	}
	
	public function show(isEndLess:Bool,  text:String, onFinish=null ) 
	{
		_width = 105;
		
		percent = 0;
		this.isEndLess = isEndLess;
		this.onFinish = onFinish;
		addEventListener( Event.ENTER_FRAME, update);
		
		label.text = text;
		addChild(graphic);
		
		Space.Resize();
	}
}