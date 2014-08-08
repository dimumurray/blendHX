package ::packageName::;

import blendhx.core.components.*;

class ::className:: extends Component
{
	//constructer called at start up
	public function new()
	{
	}
	
	//calls every frame
	override public function update():Void
	{
		
	}
	
	//called when the parent gameobject is destroyed
	override public function destroy():Void
	{
		//base class destroy call once after your own cleanup
		super.destroy();
	}
}