package com.blendhx.core.assets;
import flash.events.ErrorEvent;

import com.blendhx.core.systems.RenderingSystem;
import com.blendhx.editor.*;
import flash.events.IOErrorEvent;
import flash.errors.Error;
import flash.net.URLRequest;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.utils.ByteArray;
import flash.display3D.textures.Texture;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3D;
import flash.events.Event;


class TextureLoader
{
	public var width:UInt;
	public var height:UInt;
	public var texture:Texture;
	public var sourceURL:String;
	public var casheURL:String;
	public var onTextureReady:Event->Void;
	
	private var urlLoader:URLLoader;
	private var bytes:ByteArray;
	
	public function new(sourceURL:String, casheURL:String, width:UInt, height:UInt, onTextureReady:Event->Void) 
	{
		this.casheURL = casheURL;
		this.sourceURL = sourceURL;
		this.width = width;
		this.height = height;
		this.onTextureReady = onTextureReady;
		
		load();
	}
	
	public function load()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, wellNowTryUploading );
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		var urlRequest:URLRequest = new URLRequest(Assets.casheDirectory.resolvePath( casheURL ).nativePath);
		urlLoader.load(urlRequest);
	}
	private function onIOError(e:IOErrorEvent):Void
	{
		Debug.Log( e.text);
	}
	private function onError(e:ErrorEvent)
	{
		Debug.Log(casheURL + ": " + e.text);
		onTextureReady(null);
	}
	
	private function wellNowTryUploading(event:Event)
	{
		var context3D:Context3D = RenderingSystem.getInstance().context3D;

		bytes = urlLoader.data;
		texture = context3D.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
		texture.addEventListener(Event.TEXTURE_READY, onTextureReady);
		texture.addEventListener(ErrorEvent.ERROR, onError);
		
		texture.uploadCompressedTextureFromByteArray(bytes, 0, true);
		
		bytes.clear();
		bytes = null;
		
		urlLoader.removeEventListener(Event.COMPLETE, wellNowTryUploading);
		urlLoader = null;
	}	
}
