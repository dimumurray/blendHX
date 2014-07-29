package scripts;

import flash.ui.Keyboard;
import flash.display.Stage;

/**
* @author 
 */
class CameraController extends Component
{
	private var keys : Array<Bool>;
	private var camera:Camera;
	
	public function new() 
	{
		keys = [];
		var stage:Stage = Singleton.getInstance().stage;
		stage.addEventListener( flash.events.KeyboardEvent.KEY_DOWN, onKey.bind(true) );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_UP, onKey.bind(false) );
	}
	
	override public function update()
	{
		if( keys[Keyboard.UP] )
			camera.moveAxis(0,-0.1);
		if( keys[Keyboard.DOWN] )
			camera.moveAxis(0,0.1);
		if( keys[Keyboard.LEFT] )
			camera.moveAxis(-0.1,0);
		if( keys[Keyboard.RIGHT] )
			camera.moveAxis(0.1, 0);
		if( keys[109] )
			camera.zoom /= 1.05;
		if( keys[107] )
			camera.zoom *= 1.05;
	}
	
	override public function setParent(_parent:GameObject):Void
	{
		parent = _parent;
		camera = parent.getChild(Camera);
	}
	public function onKey( down, e : flash.events.KeyboardEvent ) 
	{
		keys[e.keyCode] = down;
	}
}
