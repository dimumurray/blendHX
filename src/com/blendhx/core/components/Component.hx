package com.blendhx.core.components;

/**
* @author 
 */
class Component
{
	public var enabled:Bool = true;
	public var parent:Entity;
	public var children: Array<Component>;
	public var name:String = "Component";
	public var transform:Transform;
	
	public function update():Void{}
	public function initilize():Void{}
	public function uninitilize():Void{}
	public function destroy()
	{
		uninitilize();
	}
	public function clone():Dynamic{return null;}
	
	//when component parent is changed, the transform component should as well be
	public function setParent(parent : Entity)
	{
		this.parent = parent;
		if(parent != null)
			transform = parent.getChild(Transform);
		initilize();
	}
}