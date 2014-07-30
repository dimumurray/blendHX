package com.blendhx.editor;

import com.blendhx.core.*;
import com.blendhx.core.assets.*;
import com.blendhx.core.components.*;
import com.blendhx.editor.*;
/**
* @author 
 */
class RegisterClassAlias
{
	public static function Register() 
	{
		haxe.remoting.AMFConnection.registerClassAlias("haxe.ds.StringMap", haxe.ds.StringMap);
		
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.assets.Material", Material);
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.assets.Mesh", Mesh);
		
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.components.Transform", Transform);
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.components.Component", Component);
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.components.Camera", Camera);
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.components.GameObject", GameObject);
		haxe.remoting.AMFConnection.registerClassAlias("com.blendhx.core.components.MeshRenderer", MeshRenderer);
	}	
}