package com.blendhx.editor.panels;
import flash.text.TextFieldAutoSize;
import flash.system.ApplicationDomain;

import com.blendhx.core.components.GameObject;
import com.blendhx.editor.uicomponents.Button;
import com.blendhx.editor.uicomponents.TextInput;
import com.blendhx.editor.data.AS3DefenitionHelper;
import com.blendhx.editor.Selection;
import com.blendhx.core.*;
import com.blendhx.editor.spaces.*;
import com.blendhx.editor.panels.*;
import com.blendhx.core.components.*;
import flash.events.Event;
import flash.display.Graphics;

/**
* @author 
 */
class HierarchyPanel extends Panel
{
	private static var instance:HierarchyPanel;
	
	public var hierarchyItems:Array<HierarchyItem>;
	private var hierarchyItemPool:Array<HierarchyItem>;
	public static var identWidth:Float = 20;
	public static var padding:Float = 20;
	private var renameInput:TextInput;
	private var rightClickedGameobject:GameObject;
	
	public static inline function getInstance():HierarchyPanel
  	{
    	if (instance == null)
          return instance = new HierarchyPanel();
      	else
          return instance;
  	}	
	
	public function new() 
	{
		super("Hierarchy", Space.SPACE_WIDTH/(3/2));
		
		hierarchyItems = new Array<HierarchyItem>();
		hierarchyItemPool = new Array<HierarchyItem>();
		

		drawGraphics();
	}
	
	public function renameGameObject(hierarchyItem:HierarchyItem)
	{
		rightClickedGameobject = hierarchyItem.gameobject;
		
		if(renameInput == null)
		{
			renameInput = new TextInput("", 999, 999, 0, removeRenameBox, this);
			elements.remove(renameInput);
		}
	
		addChild(renameInput);
		renameInput.label.autoSize = TextFieldAutoSize.LEFT;
		renameInput.setValue( rightClickedGameobject.name );
		renameInput.onMouseDown(null);
		
		renameInput.label.setSelection(0, rightClickedGameobject.name.length);
		renameInput.x = 2;
		renameInput.y = hierarchyItem.y;
		renameInput._height = 19;
		renameInput._width = _width - 4;
		renameInput.resize();
	}
	public function removeRenameBox()
	{
		
		try
		{
			removeChild(renameInput);
		}
		catch(e:Dynamic)
		{
			return;
		}
		rightClickedGameobject.name = renameInput.value;
		populate();
	}
	
	public function clearItems() 
	{
		
		for (item in hierarchyItems)
		{
			removeChild( item );
		}
	
		hierarchyItems = [];
	}
	private function getItemFromPool(gameObject:GameObject, depth:UInt)
	{
		var item:HierarchyItem;
			
		if( hierarchyItemPool[hierarchyItems.length] == null)
		{
			item = new HierarchyItem(gameObject, depth);
			hierarchyItemPool.push(item);
		}
		
		item = hierarchyItemPool[hierarchyItems.length];
		item.init(gameObject, depth);
		
		return item;
			
	}
	public function push(gameObject:GameObject, depth:UInt):HierarchyItem
	{
		var item:HierarchyItem = getItemFromPool(gameObject, depth);
		item.y = hierarchyItems.length * padding + 2;
		
		hierarchyItems.push( item );
		addChild( item );
		
		return item;
	}
	private function reverseAddChild()
	{
		//n is used for reverse aray iteration!
		var n:Int = hierarchyItems.length - 1;

		for (i in 0 ... hierarchyItems.length) 
		{
			addChild( hierarchyItems[n] );
			n--;
		}
	 
		
	}

	override public function drawGraphics()
	{
		if(parent == null)return;
		
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0x787878);
		
		var gridY:Float = 2;
		_height = cast(parent, Space)._height;
		while(gridY < _height)
		{
			g.drawRect(2, gridY, _width-3, padding);
			gridY += padding * 2;
		}
		g.endFill();

		for (item in hierarchyItems)
		{
			item.drawGraphics();
		}

	}

	override public function resize()
	{
		drawGraphics();
		for (element in elements)
		{
			element.resize();
		}
	}
		
	public function populate()
	{
		clearItems();
		lastParent = [];
		pushIntoHierarchy(Scene.getInstance(), 0);
		reverseAddChild();
		drawGraphics();
	}
	
	var lastParent:Array<HierarchyItem> = new Array<HierarchyItem>();


	private function pushIntoHierarchy(gameObject:Component, depth:UInt = 0):Bool
	{
		var deep:UInt = 1;
		//proceed if object is of type GameObject
		//trace( AS3DefenitionHelper.ObjectIsOfType(gameObject, GameObject) );  //. flash.utils.getDefenitionByName();
		if ( AS3DefenitionHelper.ObjectIsOfType(gameObject, GameObject) )
		{
			//puhsing the item into the hierarch
			var item:HierarchyItem = push( cast(gameObject, GameObject), depth );
			item.numberInHierarchy = hierarchyItems.length;
			item.parentInHierarchy = lastParent[depth-1];
			
			//setting parent for next tree items
			if(gameObject.children.length>=2)
			{
				switch (Type.getClass(gameObject.children[1]))
				{
					case Camera:
						item.type = HierarchyItem.CAMERA;
					case MeshRenderer:
						item.type = HierarchyItem.MESH;
					default:
						item.type = HierarchyItem.TRANSFORM;
				}
				
				lastParent[depth] = item;
			}
			
			
			for (child in gameObject.children)
			{
				if (pushIntoHierarchy(child, deep + depth) == true)
					item.hasChildren = true;
				else if(item.hasChildren == true)
					item.hasChildren = true;
				else 
					item.hasChildren = false;
			}
			
			// means gameobject that we push has children gameobjects
			return true;
		}
		else 
		{
			// means gameobject that we push has no children gameobjects
			return false;
		}
	}
}