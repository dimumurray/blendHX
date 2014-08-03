package com.blendhx.core.components;

import flash.display.Stage;
import flash.geom.Vector3D;
import flash.accessibility.Accessibility;
import flash.geom.Matrix3D;
import com.adobe.utils.PerspectiveMatrix3D;


class Camera extends Component
{
	public var projection:PerspectiveMatrix3D;
	private var aspectRatio:Float =  1;
	public var fov:Float = 60;
	public var near:Float = 0.1;
	public var far:Float = 1000;
	private var viewProjection:Matrix3D;
	
	public function new() 
	{
		name = "Camera";
		viewProjection = new Matrix3D();
		projection = new PerspectiveMatrix3D();
		projection.perspectiveFieldOfViewLH(fov*Math.PI/180, aspectRatio, near, far);
	}
	
	override public function clone():Dynamic
	{
		var copy:Camera = new Camera();
		copy.enabled = enabled;
		copy.name = name;
		copy.projection = new PerspectiveMatrix3D( projection.rawData );
		copy.aspectRatio = aspectRatio;
		copy.fov = fov;
		copy.near = near;
		copy.far = far;
		copy.viewProjection = viewProjection.clone();
		
		return copy;
	}
	
	override public function destroy()
	{
		super.destroy();
		projection = null;
		viewProjection = null;
	}
	
	
	public function resize(width:Int=0, height:Int=0)
	{
		if( height > 0 && width > 0)
			aspectRatio =  width / height;
		
		projection.perspectiveFieldOfViewLH(fov*Math.PI/180, aspectRatio, near, far);
	}
	
	public function getViewProjection():Matrix3D
	{
		viewProjection.identity();
		viewProjection.append(transform.getMatrix());
		viewProjection.append(projection);
		return viewProjection;
	}
	


}