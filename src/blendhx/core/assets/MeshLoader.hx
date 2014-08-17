package blendhx.core.assets;

import blendhx.core.systems.RenderingSystem;
import openfl.events.IOErrorEvent;
import openfl.errors.Error;
import openfl.net.URLRequest;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLLoader;
import openfl.utils.ByteArray;
import openfl.display3D.Context3D;
import openfl.Vector;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import blendhx.editor.data.ObjParser;
import openfl.events.Event;

//manages parsing OBJ's
//instantiated only by IO.ImportOBJ() and never used again
class MeshLoader
{	
	public var casheURL:String;
	public var sourceURL:String;
	public var onMeshReady:Mesh->Void;
	private var urlLoader:URLLoader;
	private var meshIndexData:Vector<UInt>;
	private var meshVertexData:Vector<Float>;
	
	public function new(sourceURL:String, casheURL:String, onMeshReady:Mesh->Void)
	{
		this.sourceURL = sourceURL;
		this.casheURL = casheURL;
		this.onMeshReady = onMeshReady;
		
		load();
	}
	
	public function load()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

		var urlRequest:URLRequest = new URLRequest(Assets.sourceDirectory.resolvePath( sourceURL ).nativePath);
		urlLoader.load(urlRequest);
	}
	
	private function loadCompleteHandler(_):Void
	{
		parseObj(urlLoader.data);
		
		var mesh:Mesh = new Mesh( sourceURL, casheURL );
		mesh.meshIndexData = meshIndexData;
		mesh.meshVertexData = meshVertexData;
		mesh.triangles = Std.int( meshIndexData.length/3);
		
		onMeshReady(mesh);
		
		destroy();
	}
	private function parseObj(bytes:ByteArray):Void
	{
		var myObjMesh:ObjParser = new ObjParser(bytes, 1);
		meshIndexData = myObjMesh.GetIndexData();
		meshVertexData = myObjMesh.GetVertexData(true, false, false);
	}
	
	private function onIOError(e:IOErrorEvent):Void
	{
		destroy();
		trace(e.text);
	}
	
	private function destroy()
	{
		urlLoader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.data = null;
		urlLoader = null;
		onMeshReady = null;
	}
}
