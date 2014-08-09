package blendhx.editor;
import blendhx.core.assets.Assets;
import flash.Vector;
import blendhx.core.assets.Mesh;

/**
 * GPL
 */

class GridFloorMesh extends Mesh
{
	var indexArray:Array<UInt> =  [
            2,1,0, //front face
            3,2,0,
            4,7,5, //bottom face
            7,6,5,
            8,11,9, //back face
            9,11,10,
            12,15,13, //top face
            13,15,14,
            16,19,17, //left face
            17,19,18,
            20,23,21, //right face
            21,23,22
        ];
	
        var vertexArray:Array<Float> = [
                // x,y,z    r,g,b,a
                0,0,0, 1,0,0,0, //front face
                0,1,0, 0,1,0,0, 
                1,1,0, 0,0,1,0, 
                1,0,0, 0,0,0,1, 
                
                0,0,0, 1,0,0,0,//bottom face
                1,0,0, 0,1,0,0,
                1,0,1, 0,0,1,0,
                0,0,1, 0,0,0,1,
                
                0,0,1, 1,0,0,0,//back face
                1,0,1, 0,1,0,0,
                1,1,1, 0,0,1,0,
                0,1,1, 0,0,0,1,
                
                0,1,1, 1,0,0,0,//top face
                1,1,1, 0,1,0,0,
                1,1,0, 0,0,1,0,
                0,1,0, 0,0,0,1,
                
                0,1,1, 1,0,0,0,//left face
                0,1,0, 0,1,0,0,
                0,0,0, 0,0,1,0,
                0,0,1, 0,0,0,1,
                
                1,1,0, 1,0,0,0,//right face
                1,1,1, 0,1,0,0,
                1,0,1, 0,0,1,0,
                1,0,0, 0,0,0,1
            ];
	
	public function new()
	{
		super("grid", "grid");
		meshIndexData = Vector.ofArray( indexArray );
		meshVertexData = Vector.ofArray( vertexArray );
		numVertexAttributes = 7;
		uploadBuffers();
	}
}