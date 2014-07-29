package scripts;

import com.blendhx.core.*;
import com.blendhx.core.components.*;
import flash.geom.Vector3D;
/**
* @author 
 */
class CameraRotate extends Component
{
	private var camera:Camera;
	
	override public function setParent(_parent : GameObject)
	{
		super.setParent(_parent);
		
		transform = parent.getChild(Transform);
		camera = parent.getChild(Camera);
	}
	
	override public function update():Void
	{
		if (!enabled)
			return;
		
		if(transform == null)
			return;
		
		//transform.matrix.identity();
		//transform.matrix.appendRotation(flash.Lib.getTimer()/50, Vector3D.Y_AXIS);
		//transform.matrix.appendRotation(-15, Vector3D.X_AXIS);
		//transform.matrix.appendTranslation(0,0,3);
		
		camera.m.identity();
		camera.m.appendRotation(flash.Lib.getTimer()/50, Vector3D.Y_AXIS);
		camera.m.appendRotation(-15, Vector3D.X_AXIS);
		camera.m.append(transform.matrix);
		camera.m.append(camera.projection);
	}
}