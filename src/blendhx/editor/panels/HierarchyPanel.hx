package blendhx.editor.panels;
import flash.text.TextFieldAutoSize;
import flash.system.ApplicationDomain;

import blendhx.core.Utils;
import blendhx.core.components.Entity;
import blendhx.editor.uicomponents.Button;
import blendhx.editor.uicomponents.TextInput;
import blendhx.editor.data.AS3DefinitionHelper;
import blendhx.editor.Selection;
import blendhx.core.*;
import blendhx.editor.spaces.*;
import blendhx.editor.panels.*;
import blendhx.core.components.*;
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
	private var rightClickedEntity:Entity;
	
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
	
	public function renameEntity(hierarchyItem:HierarchyItem)
	{
		rightClickedEntity = hierarchyItem.entity;
		
		if(rightClickedEntity.name == "Editor" || rightClickedEntity.name == "Objects")
			return;
		
		if(renameInput == null)
		{
			renameInput = new TextInput("", 999, 999, 0, removeRenameBox, this);
			elements.remove(renameInput);
		}
	
		addChild(renameInput);
		renameInput.label.autoSize = TextFieldAutoSize.LEFT;
		renameInput.value = rightClickedEntity.name;
		renameInput.onMouseDown(null);
		
		renameInput.label.setSelection(0, rightClickedEntity.name.length);
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
		rightClickedEntity.name = renameInput.value;
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
	private function getItemFromPool(entity:Entity, depth:UInt)
	{
		var item:HierarchyItem;
			
		if( hierarchyItemPool[hierarchyItems.length] == null)
		{
			item = new HierarchyItem(entity, depth);
			hierarchyItemPool.push(item);
		}
		
		item = hierarchyItemPool[hierarchyItems.length];
		item.init(entity, depth);
		
		return item;
			
	}
	public function push(entity:Entity, depth:UInt):HierarchyItem
	{
		var item:HierarchyItem = getItemFromPool(entity, depth);
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


	private function pushIntoHierarchy(entity:Component, depth:UInt = 0):Bool
	{
		var deep:UInt = 1;
		//proceed if object is of type Entity
		//trace( AS3DefinitionHelper.ObjectIsOfType(entity, Entity) );  //. flash.utils.getDefinitionByName();
		if ( AS3DefinitionHelper.ObjectIsOfType(entity, Entity) )
		{
			//puhsing the item into the hierarch
			var item:HierarchyItem = push( cast(entity, Entity), depth );
			item.numberInHierarchy = hierarchyItems.length;
			item.parentInHierarchy = lastParent[depth-1];
			
			//setting parent for next tree items
			if(entity.children.length>=2)
			{
				switch ( Utils.GetClassFromAnyDomain( entity.children[1] ) )
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
			
			
			for (child in entity.children)
			{
				if(item.entity.collapsedInEditor == true)
					continue;
			
				if (pushIntoHierarchy(child, deep + depth) == true)
					item.hasChildren = true;
				else if(item.hasChildren == true)
					item.hasChildren = true;
				else 
					item.hasChildren = false;
			
				
			}
			
			// means entity that we push has children entitys
			return true;
		}
		else 
		{
			// means entity that we push has no children entitys
			return false;
		}
	}
}