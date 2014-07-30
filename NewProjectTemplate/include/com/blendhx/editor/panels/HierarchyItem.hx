package com.blendhx.editor.panels;
import com.blendhx.editor.assets.FileType;
import flash.display.Bitmap;
import flash.text.TextFieldAutoSize;


import com.blendhx.core.*;
import com.blendhx.core.components.GameObject;
import com.blendhx.editor.Selection;
import com.blendhx.editor.assets.*;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.spaces.Space;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextFormatAlign;
import flash.events.MouseEvent;

/**
* @author 
 */

class HierarchyItem extends DragableItem
{
	public var gameobject:GameObject;
	public var parentInHierarchy:HierarchyItem;
	public var numberInHierarchy:UInt;
	public var depth:UInt;
	public var hasChildren:Bool;
	public var icon:Sprite;
	public var type:UInt;

	public static var MESH:UInt = 32;
	public static var TRANSFORM:UInt = 0;
	public static var LAMP:UInt = 16;
	public static var CAMERA:UInt = 48;
	
	public static var Images:BitmapData = new Images.HierarchyImages(0, 0);
	
	private var textField:SimpleTextField;
	
	
	public function new(gameobject:GameObject, depth:UInt) 
	{
		super();
		
		textField = new SimpleTextField(TextFormatAlign.LEFT);
		textField.multiline = false;
		
		icon = new Sprite();
		dragGraphic = new BitmapData(200,20, true,0x00FFFFFF);
		
		addChild(textField);
		addChild(icon);
		
		init(gameobject, depth);
		
		addEventListener(MouseEvent.CLICK, select);
		addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
	}
	
	
	
	public function init(gameobject:GameObject, depth:UInt) 
	{
		x = HierarchyPanel.identWidth;
		
		textField.text = gameobject.name;
		textField.height = 20;
		this.gameobject = gameobject;
		this.depth = depth;
		textField.x = HierarchyPanel.identWidth + (depth * HierarchyPanel.identWidth);
		hasChildren = false;
		type = HierarchyItem.TRANSFORM;
		
		this.dragValue = gameobject;
		this.dragText = gameobject.name;
		this.dragType = FileType.GAMEOBJECT;
		
		drawGraphics();
	}
	
	public function onRightClick(e:MouseEvent)
	{
		isPoterntialyDragging = false;
		RightClickMenu.GameObjectMenu(this.gameobject);
		Selection.ClearDragObject(null);
	}
	
	public function select(e:MouseEvent)
	{
		Selection.Select( this );
		
		textField.textColor = 0xffffff;
	}
	
	public function deselect()
	{
		textField.textColor = 0x000000;
		drawGraphics();
	}
	
	public function drawGraphics()
	{
		textField.x = HierarchyPanel.identWidth + (depth * HierarchyPanel.identWidth);
		textField.width = Space.GetSpace(Space.HIERARCHY)._width - textField.x -  30;
		var g:Graphics = graphics;
		g.clear();
		

		g.lineStyle(1, 0x444444, 1);
		g.moveTo(textField.x, HierarchyPanel.padding/2);
		g.lineTo(textField.x - HierarchyPanel.identWidth , HierarchyPanel.padding/2);
		
		if(parentInHierarchy != null)
		{
			g.lineTo(textField.x - HierarchyPanel.identWidth, parentInHierarchy.y - y + HierarchyPanel.padding/2);
		}
		
		if (hasChildren)
		{
			g.beginFill(0xd4d4d4, 1);
			g.lineStyle(1, 0x222222, 1);
			g.drawCircle(textField.x - HierarchyPanel.identWidth , HierarchyPanel.padding/2 + 0.5, 4);
			g.endFill();
			
			g.lineStyle(1, 0x111111, 1);
			g.moveTo(textField.x - HierarchyPanel.identWidth -2, HierarchyPanel.padding/2);
			g.lineTo(textField.x - HierarchyPanel.identWidth +2, HierarchyPanel.padding/2);
		}
		
		if ( Selection.isHierarchyItem() && Selection.GetSelectedHierarchyItem() == this)
		{
			g.beginFill(0xec8e2a, .5);
			g.lineStyle(0, 0, 0);
			g.drawCircle(textField.x , HierarchyPanel.padding/2, 9);
			g.endFill();
		}
			
		var matrix:Matrix = new Matrix();
  		matrix.translate(-type, HierarchyPanel.padding/2);
		
		g = icon.graphics;
		g.clear();
		g.beginBitmapFill(HierarchyItem.Images, matrix);
		g.drawRect(0, HierarchyPanel.padding/2, 16, 16);
		g.endFill();
		icon.x = textField.x - 8;
		icon.y = 0 - HierarchyPanel.padding/2 + 2;
		
		textField.x += 9;
		
		matrix.identity();
		
		dragGraphic.fillRect(dragGraphic.rect, 0x00000000);
		matrix.translate(HierarchyPanel.padding/2, -HierarchyPanel.padding/2);
		dragGraphic.draw(icon, matrix);
		matrix.translate(HierarchyPanel.padding/2 + 8, HierarchyPanel.padding/2);
		dragGraphic.draw(textField, matrix);
	}
	
}