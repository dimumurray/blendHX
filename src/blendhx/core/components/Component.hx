package blendhx.core.components;

/**
* @author 
 */
class Component
{
	public var editorProperties:Array<String> = [];
	public var properties:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	public var enabled:Bool = true;
	public var children: Array<Component>;
	public var name:String = "Component";
	public var transform:Transform;
	@:isVar public var parent(get, set):Entity;
	
	public function updateProperties(values:Array<Dynamic>){}
	public function update():Void{}
	public function initilize():Void{}
	public function uninitilize():Void{}
	public function destroy()
	{
		uninitilize();
	}
	public function clone():Dynamic{return null;}
	
	//when component parent is changed, the transform component should as well be
	public function get_parent() { return parent; }
	
	public function set_parent(value)
	{
		parent = value;
		if(parent != null)
			transform = parent.getChild(Transform);
        initilize();
		
		return parent;
	}
}