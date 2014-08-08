package blendhx.core.assets;

import blendhx.core.systems.RenderingSystem;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.Context3D;
import flash.utils.ByteArray;
import flash.Vector;



/*
Instance of the classes are accesible by Assets.GetMesh()
They are created only by MeshLoader at the time of parsing OBJ
*/

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
	
	public function destroy()
	{
		meshIndexData = null;
		meshVertexData = null;
		vertexBuffer.dispose();
		indexBuffer.dispose();
	}
}
		