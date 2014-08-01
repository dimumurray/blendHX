package com.blendhx.core.components;

/**
* @author 
 */
class Component
{
	public var enabled:Bool = true;
	public var parent:GameObject;
	public var children: Array<Component>;
	public var name:String = "Component";
	public var transform:Transform;
	
	public function update():Void
	{
	}
	public function init():Void
	{
	}
	
	public function destroy()
	{
	}
	//when component parent is changed, the transform component should as well be
	public function setParent(parent : GameObject)
	{
		this.parent = parent;
		if(parent == null)
			return;
		transform = parent.getChild(Transform);
	}
}