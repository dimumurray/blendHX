package com.blendhx.core.components;

/**
* @author 
 */
class GameObject extends Component
{
	
	public function new(name:String = "GameObject") 
	{
		children = new Array<Component>();
		
		addChild( new Transform() );
		this.name = name;
	}
	
	override public function update():Void
	{
		if (!enabled)
			return;

		for (child in children)
			 child.update();

	}
	override public function init()
	{
		for (child in children)
		{
			child.init();
		}
	}
	override public function unset()
	{
		for (child in children)
			child.unset();
	}
		
	override public function destroy()
	{
		for (child in children)
			child.destroy();
	}

	public function addChild(child:Component)
	{
		children.push(child);
		child.setParent(this);
	}

	public function removeChild(child:Component)
	{
		children.remove(child);
		child.destroy();
	}
	

	public function getChild( componentType:Class<Dynamic> ):Dynamic
	{
		var className:String = Type.getClassName(componentType);
		for (child in children)
		{
			var childClassName:String = Type.getClassName(Type.getClass(child));
			var childSuperClassName:String = Type.getClassName(Type.getSuperClass(Type.getClass(child)));
			
			if( childClassName ==  className || childSuperClassName ==  className)
			{
				return child;
			}
		}
		return null;
	}
}