package com.blendhx.core.components;

import flash.geom.Matrix3D;

/**
* @author 
 */
class Transform extends Component
{
	public var matrix:Matrix3D;
	
	public function new() 
	{
		name = "Camera";
		matrix = new Matrix3D();
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
	
	public function appendTranslation(_x:Float, _y:Float, _z:Float):Void
	{
		matrix.prependTranslation(_x, _y, _z);
	}
	
	public function getMatrix():Matrix3D
	{
		var parentENTITYMatrix:Matrix3D = null;
		var resolvedMatrix:Matrix3D = null;
		if(parent.parent != null)
			parentENTITYMatrix = parent.parent.transform.getMatrix();
		if(parentENTITYMatrix != null)
		{
			resolvedMatrix = matrix.clone();
			resolvedMatrix.appendTranslation(parentENTITYMatrix.position.x, parentENTITYMatrix.position.y,parentENTITYMatrix.position.z);
		
		}
		else
			resolvedMatrix = matrix;
											 
		
		
		return resolvedMatrix;
	}
}