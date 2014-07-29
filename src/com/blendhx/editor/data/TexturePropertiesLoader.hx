package com.blendhx.editor.data;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.filesystem.*;
import flash.display.Loader;
import flash.utils.ByteArray;
import flash.events.Event;
/**

 * GPL

 */
class TexturePropertiesLoader
{
	var loader:Loader;
	public var width:Int;
	public var height:Int;
	public var file:File;
	public var onComplete:TexturePropertiesLoader->Void;
	
	private function onLoaderComplete( e:Event )
	{
		width = Std.int( loader.width );
		height = Std.int( loader.height);
		
		if( isPowerOfTwo(width) && isPowerOfTwo(height))
			onComplete( this );
		else
			Debug.Log("Non power of 2");
	}
	private function onError( e:IOErrorEvent )
	{
		Debug.Log("File corrupt");
	}
	private inline function isPowerOfTwo(n:Int):Bool
	{
		return (n & (n - 1)) == 0;
	}
	public function new( file:File, onComplete:TexturePropertiesLoader->Void ) 
	{
		this.file = file;
		this.onComplete = onComplete;
		loader = new Loader();
		var stream = new FileStream();
		var bytes:ByteArray = new ByteArray();
		stream.open(file, FileMode.READ);
		stream.readBytes(bytes, 0, stream.bytesAvailable);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		loader.loadBytes( bytes );
	}	
}