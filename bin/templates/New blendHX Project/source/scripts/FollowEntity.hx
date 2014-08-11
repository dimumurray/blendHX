package scripts;

import blendhx.core.components.*;

class FollowEntity extends Component
{
	private var lag:Float = 2;
	private var targetEntity:Entity = null;
	//constructer called at start up
	public function new()
	{
		editorProperties = ["Lag", "Float", "Target Entity", "Entity"];
	}
	override public function updateProperties(values:Array<Dynamic>)
	{
		lag = values[0];
		targetEntity = values[1];
	}
	
	//calls every frame
	override public function update():Void
	{
		if(targetEntity != null)
		{
			transform.x += (targetEntity.transform.x - transform.x) / lag;
			transform.y += (targetEntity.transform.y - transform.y) / lag;
			transform.y += (targetEntity.transform.y - transform.y) / lag;
		}
	}
	
	//called when the parent gameobject is destroyed
	override public function destroy():Void
	{
		targetEntity = null;
		//base class destroy call once after your own cleanup
		super.destroy();
	}
}