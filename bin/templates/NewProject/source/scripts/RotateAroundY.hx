package scripts;

import com.blendhx.core.components.*;
import flash.geom.Vector3D;

class RotateAroundY extends Component
{
	override public function update():Void
	{
		if (!enabled)
			return;
			
		transform.matrix.appendRotation(-1, Vector3D.Y_AXIS);
	}
}