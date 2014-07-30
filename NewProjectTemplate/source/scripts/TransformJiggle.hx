package scripts;

import com.blendhx.core.*;
import com.blendhx.core.components.*;
import flash.geom.Vector3D;
/**
* @author 
 */
class TransformJiggle extends Component
{
	override public function setParent(_parent : GameObject)
	{
		super.setParent(_parent);
		
		transform = parent.getChild(Transform);
	}
	
	override public function update():Void
	{
		if (!enabled)
			return;
		
		if(transform == null)
			return;
		
		transform.matrix.identity();
		transform.matrix.appendTranslation(Math.random()/10,Math.random()/10,Math.random()/10);
	}
}