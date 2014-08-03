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
		var parentGameobjectMatrix:Matrix3D = null;
		var resolvedMatrix:Matrix3D = null;
		if(parent.parent != null)
			parentGameobjectMatrix = parent.parent.transform.getMatrix();
		if(parentGameobjectMatrix != null)
		{
			resolvedMatrix = matrix.clone();
			resolvedMatrix.appendTranslation(parentGameobjectMatrix.position.x, parentGameobjectMatrix.position.y,parentGameobjectMatrix.position.z);
		
		}
		else
			resolvedMatrix = matrix;
											 
		
		
		return resolvedMatrix;
	}
}