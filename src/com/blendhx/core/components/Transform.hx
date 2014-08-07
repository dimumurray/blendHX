package com.blendhx.core.components;

import flash.geom.Vector3D;
import flash.geom.Matrix3D;

/**
* @author 
 */
class Transform extends Component
{
	private var matrix:Matrix3D;
	private var hasChanged:Bool;
	
	@:isVar public var x(get, set):Float = 0;
	@:isVar public var y(get, set):Float = 0;
	@:isVar public var z(get, set):Float = 0;
	
	@:isVar public var rotationX(get, set):Float = 0;
	@:isVar public var rotationY(get, set):Float = 0;
	@:isVar public var rotationZ(get, set):Float = 0;
	
	@:isVar public var scaleX(get, set):Float = 1;
	@:isVar public var scaleY(get, set):Float = 1;
	@:isVar public var scaleZ(get, set):Float = 1;
	
	public function get_x() { return x; }
	public function set_x(param:Float):Float
	{
		if(param != x)
		{
			hasChanged = true;
			x = param;
		}
		return param;
	}
	
	public function get_y() { return y; }
	public function set_y(param:Float):Float
	{
		if(param != y)
		{
			hasChanged = true;
			y = param;
		}
		return param;
	}
	
	public function get_z() { return z; }
	public function set_z(param:Float):Float
	{
		if(param != z)
		{
			hasChanged = true;
			z = param;
		}
		return param;
	}
	// rotation getter setter
	public function get_rotationX() { return rotationX; }
	public function set_rotationX(param:Float):Float
	{
		if(param != rotationX)
		{
			hasChanged = true;
			rotationX = (param + 365) % 365;
		}
		return param;
	}
	
	public function get_rotationY() { return rotationY ; }
	public function set_rotationY(param:Float):Float
	{
		if(param != rotationY)
		{
			hasChanged = true;
			rotationY = (param + 365) % 365;
		}
		return param;
	}
	
	public function get_rotationZ() { return rotationZ; }
	public function set_rotationZ(param:Float):Float
	{
		if(param != rotationZ)
		{
			hasChanged = true;
			rotationZ = (param + 365) % 365;
		}
		return param;
	}
	//scale get set
	public function get_scaleX() { return scaleX; }
	public function set_scaleX(param:Float):Float
	{
		if(param != scaleX)
		{
			if(param == 0)
				param = 0.001;
			hasChanged = true;
			scaleX = param;
		}
		return param;
	}
	public function get_scaleY() { return scaleY; }
	public function set_scaleY(param:Float):Float
	{
		if(param != scaleY)
		{
			if(param == 0)
				param = 0.001;
			hasChanged = true;
			scaleY = param;
		}
		return param;
	}
	public function get_scaleZ() { return scaleZ; }
	public function set_scaleZ(param:Float):Float
	{
		if(param != scaleZ)
		{
			if(param == 0)
				param = 0.001;
			hasChanged = true;
			scaleZ = param;
		}
		return param;
	}

	
	
	
	public function new() 
	{
		name = "Camera";
		
		composeMatrix3D();
	}
	override public function clone():Dynamic
	{
		var copy:Transform = new Transform();
		copy.enabled = enabled;
		copy.name = name;
		copy.matrix = matrix.clone();
		
		return copy;
	}
	override public function destroy()
	{
		super.destroy();
		matrix = null;
	}
	
	
	
	private function composeMatrix3D():Void
	{
		matrix = new Matrix3D();
		matrix.appendRotation(rotationX, Vector3D.X_AXIS);
		matrix.appendRotation(rotationY, Vector3D.Y_AXIS);
		matrix.appendRotation(rotationZ, Vector3D.Z_AXIS);
		matrix.appendScale(scaleX, scaleY, scaleZ);
		matrix.appendTranslation(x, y, z);
		hasChanged = false;
	}
	
	public function getMatrix():Matrix3D
	{
		if(hasChanged)
			composeMatrix3D();
			
		var parentGameobjectTransform:Transform = null;
		var resolvedMatrix:Matrix3D = null;
		if(parent.parent != null)
			parentGameobjectTransform = parent.parent.transform;
		if(parentGameobjectTransform != null)
		{
			resolvedMatrix = matrix.clone();
			resolvedMatrix.appendRotation(parentGameobjectTransform.rotationX, Vector3D.X_AXIS);
			resolvedMatrix.appendRotation(parentGameobjectTransform.rotationY, Vector3D.Y_AXIS);
			resolvedMatrix.appendRotation(parentGameobjectTransform.rotationZ, Vector3D.Z_AXIS);
			resolvedMatrix.appendTranslation(parentGameobjectTransform.x, parentGameobjectTransform.y,parentGameobjectTransform.z);
		}
		else
			resolvedMatrix = matrix;
		
		return resolvedMatrix;
	}
}