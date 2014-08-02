package com.blendhx.core.components;

import com.blendhx.editor.data.AS3DefinitionHelper;
import com.blendhx.editor.Debug;
import com.blendhx.core.Utils;
/*
Gameobjects contain components, a simple composition pattern
 */
class GameObject extends Component
{
	//basic initializations
	public function new(name:String = "GameObject") 
	{
		children = new Array<Component>();
		//there always need to be a transform component, because it's used so much
		addChild( new Transform() );
		this.name = name;
	}
	// calls child components update, if gameobject is enabled
	override public function update():Void
	{
		if (!enabled)
			return;
		//call update if child component is enabled
		for (child in children)
			if(child.enabled)
			 	child.update();
	}
	
	//upon destruction, call components to destroy
	override public function destroy()
	{
		for (child in children)
			child.destroy();
		children = [];
		transform = null;
	}
	//add a child only if there isn't one already added with the same Type. There can't be two children of the same type in one Gameobject
	public function addChild(child:Component)
	{
		var childClass:Class<Dynamic> = Utils.GetClassFromAnyDomain(child);
		var existingChildClass:Class<Dynamic> = null;
		
		if ( !AS3DefinitionHelper.ObjectIsOfType(child, GameObject) )
		{
			for (existingChild in children)
			{
				existingChildClass =  Utils.GetClassFromAnyDomain(existingChild);
				if( childClass ==  existingChildClass )
				{
					
					Debug.Log("You can't add same component twice");
					child.destroy();
					return;
				}
			}
		}
		
		children.push(child);
		child.setParent(this);
	}

	//add a component to the children list, and also let component know that we are her parent
	public function removeChild(child:Component)
	{
		children.remove(child);
		child.setParent(null);
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