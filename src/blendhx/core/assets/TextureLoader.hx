package blendhx.core.assets;

import blendhx.core.systems.RenderingSystem;
import blendhx.editor.*;

import openfl.events.IOErrorEvent;
import openfl.events.ErrorEvent;
import openfl.errors.Error;
import openfl.net.URLRequest;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLLoader;
import openfl.utils.ByteArray;
import openfl.display3D.textures.Texture;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.Context3D;
import openfl.events.Event;

//instantiated by Asset.loadTextures and IO.convertToATF
class TextureLoader
{
	public var width:UInt;
	public var height:UInt;
	public var texture:Texture;
	public var sourceURL:String;
	public var casheURL:String;
	public var onTextureReady:Void->Void;
	
	private var urlLoader:URLLoader;
	private var bytes:ByteArray;
	
	public function new(sourceURL:String, casheURL:String, width:UInt, height:UInt, onTextureReady:Void->Void) 
	{
		this.casheURL = casheURL;
		this.sourceURL = sourceURL;
		this.width = width;
		this.height = height;
		this.onTextureReady = onTextureReady;
	}
	
	// load raw png data
	public function load()
	{
		urlLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, wellNowTryUploading );
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		var urlRequest:URLRequest = new URLRequest(Assets.casheDirectory.resolvePath( casheURL ).nativePath);
		urlLoader.load(urlRequest);
	}
	private function urlLoaderIOError(e:IOErrorEvent):Void
	{
		urlLoader.removeEventListener(Event.COMPLETE, wellNowTryUploading );
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
		urlLoader = null;
		trace( e.text);
	}
	
	
	//try uploading png data to gpu buffer
	private function wellNowTryUploading(event:Event)
	{
		var context3D:Context3D = RenderingSystem.getInstance().context3D;

		bytes = urlLoader.data;
		texture = context3D.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
		
		texture.addEventListener(Event.TEXTURE_READY, onTextureReadyLocalFunction);
		texture.addEventListener(ErrorEvent.ERROR, onTextureUploadError);
		
		texture.uploadCompressedTextureFromByteArray(bytes, 0, true);
		
		bytes.clear();
		bytes = null;
		
		urlLoader.removeEventListener(Event.COMPLETE, wellNowTryUploading );
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOError);
		urlLoader.data = null;
		urlLoader = null;
	}	
	private function onTextureUploadError(e:ErrorEvent)
	{
		trace(casheURL + ": " + e.text);
		if(onTextureReady!= null)
			onTextureReady();
		
		onTextureReady = null;
		texture.removeEventListener(Event.TEXTURE_READY, onTextureReadyLocalFunction);
		texture.removeEventListener(ErrorEvent.ERROR, onTextureUploadError);
	}
	
	//now that it has finished uploading, call the callback function if any
	private function onTextureReadyLocalFunction(_)
	{
		if(onTextureReady!= null)
			onTextureReady();
		

		onTextureReady = null;
		texture.removeEventListener(Event.TEXTURE_READY, onTextureReadyLocalFunction);
		texture.removeEventListener(ErrorEvent.ERROR, onTextureUploadError);
	}
	
	public function destroy()
	{
		texture.dispose();
		texture = null;
	}
	
}
