package com.blendhx.core.assets;

import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.core.assets.*;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.Vector;
import flash.utils.ByteArray;
import flash.display3D.Context3D;

class Mesh
{
	public var meshIndexData:Vector<UInt>;
	public var meshVertexData:Vector<Float>;
	
	public var vertexBuffer:VertexBuffer3D;
	public var indexBuffer:IndexBuffer3D;
	public var numVertexAttributes:UInt = 5;
	public var casheURL:String;
	public var sourceURL:String;
	public var triangles:UInt = 0;
	
	public function new(sourceURL:String, casheURL:String)
	{
		this.sourceURL = sourceURL;
		this.casheURL = casheURL;
	}
	
	public function uploadBuffers()
	{
		var context3D:Context3D = RenderingSystem.getInstance().context3D;
		
		vertexBuffer = context3D.createVertexBuffer( Std.int(meshVertexData.length/numVertexAttributes) , numVertexAttributes); 
		vertexBuffer.uploadFromVector(meshVertexData, 0, Std.int(meshVertexData.length/numVertexAttributes));

		indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
		indexBuffer.uploadFromVector(meshIndexData, 0, meshIndexData.length);
	}

}
		