package com.blendhx.editor.panels;

import com.blendhx.core.components.GameObject;
import com.blendhx.editor.uicomponents.Button;
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
	
	public static inline function getInstance()
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
		item.y = hierarchyItems.length * padding;
		
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
		
		var gridY:Float = 0;
		_height = cast(parent, Space)._height;
		while(gridY < _height)
		{
			g.drawRect(2, gridY, _width-4, padding);
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
		y = 1;
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
		if (Type.getClass(gameObject) == GameObject || Type.getClass(gameObject) == Scene || Type.getClass(gameObject) == GridFloor)
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