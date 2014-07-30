package com.blendhx.editor.panels;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.errors.Error;

import com.blendhx.editor.Selection;
import com.blendhx.core.*;
import com.blendhx.core.assets.*;
import com.blendhx.core.components.GameObject;
import com.blendhx.editor.assets.*;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.spaces.Space;
import com.blendhx.editor.assets.FileType;
import flash.filesystem.File;
import flash.text.GridFitType;
import flash.text.AntiAliasType;
import flash.text.TextFieldAutoSize;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;

/**
* @author 
 */
class FileItem extends DragableItem
{
	public var hasChildren:Bool;
	
	public static var Images:BitmapData = new Images.FileImages(0, 0);
	
	
	public var fileName:String;
	private var textField:SimpleTextField;
	private var mouseOverIndicator:Sprite;
	private var icon:Sprite;
	public var onClick:FileItem->Void;
	public var localURL:String="";
	public var type:UInt;
	
	private var selected:Bool = false;
	
	
	public function new( fileName:String="file", extension:String="",  onClick:FileItem->Void = null) 
	{
		super();
		
		this.onClick = onClick;
		textField = new SimpleTextField(TextFormatAlign.LEFT);
		textField.height = 20;
		textField.width = AssetsPanel.colomnWidth - 30;
		textField.x = 18;
		textField.embedFonts = true;
		//textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.gridFitType = GridFitType.NONE;
		textField.thickness = -100;
		textField.textColor = 0xffffff;
		
		mouseOverIndicator = new Sprite();
		icon = new Sprite();
		dragGraphic = new BitmapData(200,20, true,0x00FFFFFF);
		
		addChild(mouseOverIndicator);
		addChild(textField);
		addChild(icon);
		
		init(fileName, extension);
		
		this.mouseChildren = false;
		this.doubleClickEnabled = true;
		addEventListener(MouseEvent.CLICK, select);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
	}
	
	override private function reparentTarget(e:MouseEvent):Void
	{
		var targetFileItem:FileItem = null;
		if( Selection.dragObject!= null)
			targetFileItem = cast(Selection.dragObject, FileItem );
		
		if( targetFileItem != null && (type == FileType.FOLDER || type == FileType.BACK))	
		{
			var targetFile:File = AssetsPanel.currentDirectory.resolvePath(targetFileItem.fileName);
			if(targetFile.isDirectory)
				return;
			var destinationFolder:File;
			
			if(type == FileType.FOLDER)
				destinationFolder = AssetsPanel.currentDirectory.resolvePath(fileName).resolvePath(targetFileItem.fileName);
			else
				destinationFolder = AssetsPanel.currentDirectory.parent.resolvePath(targetFileItem.fileName);
			
			
			try
			{
				targetFile.moveTo(destinationFolder, false);
			}
			catch(e:Error)
			{
				Debug.Log(e.message);
				return;
			}
				
			Assets.MoveAsset( getLocalURL(targetFile), getLocalURL(destinationFolder) );
				
			AssetsPanel.getInstance().populate();
		}
			
	}
	
	private inline static function getLocalURL(file:File):String
	{
		return StringTools.urlDecode(file.url.substring(Assets.sourceDirectory.url.length+1));
	}
	
	public function onDoubleClick(e:MouseEvent)
	{
	}
	public function onRightClick(e:MouseEvent)
	{
		RightClickMenu.FileItem(this);
	}
	
	public function select(e:MouseEvent)
	{	
		if( type == FileType.BACK || type == FileType.FOLDER)
		{
			onClick( this );
			return;
		}
		
		//AssetsPanel settings
		
		if(!selected)
			Selection.Select( this );
		selected = true;
		
		//drawing orange box beneath
		var g:Graphics = mouseOverIndicator.graphics;
		g.clear();
		g.beginFill(0xdd8335, .8);
		g.drawRoundRect(-2, 1, AssetsPanel.colomnWidth - 12, 18, 10);
		g.endFill();
		
	}
	
	public function deselect()
	{
		mouseOverIndicator.graphics.clear();
		
		selected = false;
	}
	
	private function onMouseOver(_):Void
	{
		if(  selected )
			return;
		
		var g:Graphics = mouseOverIndicator.graphics;
		g.clear();
		g.beginFill(0xffffff, 0.1);
		g.drawRoundRect(-2, 1, AssetsPanel.colomnWidth - 12, 18, 10);
		g.endFill();
	}
	
	override private function onMouseOut(e:MouseEvent):Void
	{
		super.onMouseOut(e);
		
		if(  !selected )
			mouseOverIndicator.graphics.clear();
		
		this.dragValue = localURL;
	}
	
	
	public function init( fileName:String, extension:String = "" ) 
	{
		this.fileName = fileName;
		textField.text = fileName;
		
		selected = false;
		
		hasChildren = false;
		type = getType(extension);
		
		drawGraphics();
		
		this.dragValue = localURL;
		this.dragText = fileName;
		this.dragType = type;
		
		mouseOverIndicator.graphics.clear();
	}
	
	private function getType(extension:String):UInt
	{
		switch (extension)
		{
			case "":
				return FileType.FOLDER;
			case "png":
				return FileType.IMAGE;
			case "atf":
				return FileType.IMAGE;
			case "blend":
				return FileType.BLENDER;
			case "back":
				return FileType.BACK;
			case "obj":
				return FileType.MESH;
			case "hx":
				return FileType.SCRIPT;
			case "as":
				return FileType.SCRIPT;
			case "mp3":
				return FileType.AUDIO;
			case "mat":
				return FileType.MATERIAL;
			default:
				return FileType.OTHERS;

		}

	}
	
	
	
	public function drawGraphics()
	{
		var g:Graphics = icon.graphics;
		g.clear();
		
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(1 , 2 + (16 - type) * 16);
		g.lineStyle(0, 0, 0);
		g.beginBitmapFill(FileItem.Images, matrix);
		g.drawRect(1,2, 16, 16);
		g.endFill();
		
		dragGraphic.fillRect(dragGraphic.rect, 0x00000000);
		dragGraphic.draw(this);
	}
}