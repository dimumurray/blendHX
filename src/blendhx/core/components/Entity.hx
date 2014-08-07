package blendhx.core.components;

import blendhx.editor.data.AS3DefinitionHelper;
import blendhx.editor.Debug;
import blendhx.core.Utils;
/*
Entitys contain components, a simple composition pattern
 */
class Entity extends Component
{
	public static var entities:Array<Entity> = [];
	public var id:UInt;
	public var collapsedInEditor:Bool = false;
	
	public static function AssignID(entity:Entity)
	{
		entities.push(entity);
		entity.id = entities.length;
	}
	public static function FindByID(id:UInt):Entity
	{
		return entities[id];
	}
	public static function RemoveFromIDList(id:UInt)
	{
		entities[id] = null;
	}
	//basic initializations
	public function new(name:String = "Entity") 
	{
		
		children = new Array<Component>();
		//there always need to be a transform component, because it's used so much
		this.name = name;
		Entity.AssignID( this );
		var transform:Transform = new Transform();
		addChild( transform );
		this.transform = transform;
	}
	
	override public function initilize():Void
	{
		for (child in children)
			 child.initilize();
	}
	
	// calls child components update, if entity is enabled
	override public function update():Void
	{
		if (!enabled)
			return;
		//call update if child component is enabled
		for (child in children)
			if(child.enabled)
			 	child.update();
	}

	override public function uninitilize():Void
	{
		for (child in children)
			 child.uninitilize();
	}
	
	override public function clone():Dynamic
	{
		var copy:Entity = new Entity();
		copy.enabled = enabled;
		copy.name = name;
		copy.collapsedInEditor = collapsedInEditor;
		for(child in children)
			copy.addChild( child.clone() );
		
		return copy;
	}
	
	
	//upon destruction, call components to destroy
	override public function destroy()
	{
		super.destroy();
		for (child in children)
		{
			child.parent = null;
			child.destroy();
		}
		children = [];
		transform = null;
		Entity.RemoveFromIDList(id);
	}
	//add a child only if there isn't one already added with the same Type. There can't be two children of the same type in one Entity
	public function addChild(child:Component)
	{
		var childClass:Class<Dynamic> = Utils.GetClassFromAnyDomain(child);
		var existingChildClass:Class<Dynamic> = null;
		
		
		for (existingChild in children)
		{
			if ( !AS3DefinitionHelper.ObjectIsOfType(child, Entity) )
			{
				existingChildClass =  Utils.GetClassFromAnyDomain(existingChild);
				if( childClass ==  existingChildClass )
				{
					Debug.Log("You can't add same component twice: "+this.name +","+ existingChild +", "+ child);
					child.destroy();
					return;
				}
			}
		
			//if child is already added
			if(existingChild == child)
				return;
		}
		
		children.push(child);
		child.parent = this;
	}
	
	override public function set_parent(value)
	{
		super.parent = null;
		parent = value;
		return parent;
	}

	//add a component to the children list, and also let component know that we are her parent
	public function removeChild(child:Component)
	{
		children.remove(child);
		child.parent = null;
	}
	
	//giving a reference to a child of a certain type
	public function getChild( componentType:Class<Dynamic> ):Dynamic
	{
		for (child in children)
		{
			var childClass:Class<Dynamic> = Utils.GetClassFromAnyDomain(child);
		
			if( childClass ==  componentType)
			{
				return child;
			}
		}

		return null;
	}
}