package scripts;

import blendhx.core.components.*;
import flash.geom.Vector3D;

class RotateAroundY extends Component
{
	@editor("Float")
	public var speed:Float = 0;
	
	@editor("Entity")
	public var target:Entity = null;
	
	override public function update():Void
	{
		transform.rotationY += speed;
		
		if(target!= null)
		transform.x = target.transform.x;
	}
}