package blendhx.editor;

import blendhx.core.*;
import blendhx.core.assets.*;
import blendhx.core.components.*;
import blendhx.editor.*;
/**
* @author 
 */
class RegisterClassAlias
{
	public static function Register() 
	{
		haxe.remoting.AMFConnection.registerClassAlias("haxe.ds.StringMap", haxe.ds.StringMap);
		haxe.remoting.AMFConnection.registerClassAlias("openfl.geom.Matrix3D", openfl.geom.Matrix3D);
		haxe.remoting.AMFConnection.registerClassAlias("openfl.geom.Vector3D", openfl.geom.Vector3D);
		
		
		haxe.remoting.AMFConnection.registerClassAlias("com.adobe.utils.PerspectiveMatrix3D4",  com.adobe.utils.PerspectiveMatrix3D);
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.assets.Material", Material);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.assets.Mesh", Mesh);
		
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.components.Transform", Transform);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.components.Component", Component);

		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.components.Camera", Camera);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.components.Entity", Entity);
		haxe.remoting.AMFConnection.registerClassAlias("blendhx.core.components.MeshRenderer", MeshRenderer);
	}	
}
