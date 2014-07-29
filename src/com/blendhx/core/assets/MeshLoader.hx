package com.blendhx.core.assets;

import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.editor.Debug;
import flash.events.IOErrorEvent;
import flash.errors.Error;
import flash.net.URLRequest;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.display3D.Context3D;
import flash.Vector;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import core.parsers.ObjParser;
import flash.events.Event;

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
		//uploadBuffers();
	}
	private function parseObj(bytes:ByteArray):Void
	{
		var myObjMesh:ObjParser = new ObjParser(bytes);
		meshIndexData = myObjMesh.GetIndexData();
		meshVertexData = myObjMesh.GetVertexData(true, false, false);
	}
	
	private function onIOError(e:IOErrorEvent):Void
	{
		Debug.Log(e.text);
	}
}