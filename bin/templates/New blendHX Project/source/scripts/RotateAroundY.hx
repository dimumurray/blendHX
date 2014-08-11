package scripts;

import blendhx.core.components.*;
import flash.geom.Vector3D;

class RotateAroundY extends Component
{
	public var speed:Float = 0;
	
	public function new()
	{
		editorProperties = ["speed", "Float"];
	}
	
	override public function updateProperties(values:Array<Dynamic>)
	{
		speed = values[0];
	}
	
	override public function update():Void
	{
		transform.rotationY += speed;
	}
}