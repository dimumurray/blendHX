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
		if (!enabled)
			return;
	}
	public function init():Void
	{
		
	}
	public function unset():Void
	{
		
	}
	public function destroy()
	{
		
	}
	public function setParent(_parent : GameObject)
	{
		parent = _parent;
		transform = parent.getChild(Transform);
	}
}