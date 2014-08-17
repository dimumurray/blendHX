package blendhx.editor;
import blendhx.core.assets.Assets;
import openfl.Vector;
import blendhx.core.assets.Mesh;

/**
 * GPL
 */

class GridFloorMesh extends Mesh
{
	private var size:UInt = 20;
	private var indexArray:Array<UInt> =  [];
	private var vertexArray:Array<Float> = [];
	
	public function new()
	{
		super("grid", "grid");
		createGrid();
		meshIndexData = Vector.ofArray( indexArray );
		meshVertexData = Vector.ofArray( vertexArray );
		numVertexAttributes = 7;
		uploadBuffers();
	}
	private function createGrid()
	{
		vertexArray = [];
		indexArray = [];
		var i:UInt = 0;
		for(x in 0...size)
		{
			var x_half:Int = Std.int( x - size / 2 );
			for(z in 0...size)
			{ 
				var z_half:Int = Std.int( z - size / 2 );
				var face:Array<Float> = [
					x_half,0,z_half, 1,0,0,0,
					x_half+1,0,z_half, 0,1,0,0,
					x_half+1,0,z_half+1, 0,0,1,0,
					x_half,0,z_half+1, 0,0,0,1, 
				];
				vertexArray = vertexArray.concat( face );
				
				var index = [
					i+2,i+1,i,
            		i+3,i+2,i
				];
				indexArray = indexArray.concat( index );
				i+=4;
			}
		}
	}
}
