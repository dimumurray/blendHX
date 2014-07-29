package com.blendhx.editor.data;
import flash.Vector;

import com.blendhx.core.assets.Mesh;
import com.blendhx.editor.data.Process;
import com.blendhx.core.assets.Assets;
import com.blendhx.core.assets.MeshLoader;
import com.blendhx.core.assets.Material;
import com.blendhx.editor.panels.AssetsPanel;
import hxsl.Shader;
import haxe.ds.StringMap;
import shaders.UnlitShader;

import flash.utils.CompressionAlgorithm;
import flash.filesystem.File;
import flash.filesystem.*;
import flash.utils.ByteArray;
import flash.net.FileReference;
import flash.events.Event;

/**

 * GPL

 */
class IO
{
	public function new() 
	{
		
	}
	
	public static function WriteMaterial( material:Material )
	{
		var shader:Dynamic = material.shader;
		material.shader = null;
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject( material );
		bytes.position = 0;
		
		var sourceFile:File = Assets.sourceDirectory.resolvePath( material.sourceURL );
		var casheFile:File = Assets.casheDirectory.resolvePath( material.casheURL );
		
		var stream = new FileStream();
		stream.open(sourceFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		
		stream.open(casheFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		
		material.shader = shader;
	}
	
	public static function LoadMaterial(sourceURL:String, casheURL:String):Material
	{
		var loadFile:File = Assets.casheDirectory.resolvePath( casheURL );
		
		
		if(!loadFile.exists)
		{
			Debug.Log("Material not found: "+loadFile.nativePath);
			return null;
		}
		
		var stream = new FileStream();
		stream.open(loadFile, FileMode.READ);
		var material:Material = stream.readObject();
		material.casheURL = casheURL;
		material.sourceURL = sourceURL;
		
		stream.close();
		
		return material;
	}
	
	public static function ImportFile( file:File )
	{
		var sourceFolderFile:File =  AssetsPanel.currentDirectory.resolvePath(file.name);
		file.copyTo(sourceFolderFile);
		encodeFile(sourceFolderFile);
	}
	
	
	public static function LoadMesh( sourceURL:String, casheURL:String ):Mesh
	{
		var loadFile:File = Assets.casheDirectory.resolvePath( casheURL );
		
		if(!loadFile.exists)
		{
			Debug.Log("Mesh not found: "+loadFile.nativePath);
			return null;
		}
		
		var stream = new FileStream();
		stream.open(loadFile, FileMode.READ);
		/*var bytes:ByteArray = new ByteArray();
		stream.readBytes(bytes, stream.bytesAvailable );
		bytes.uncompress(CompressionAlgorithm.LZMA);
		var mesh:Mesh = bytes.readObject();*/
		var mesh:Mesh = stream.readObject();
		mesh.casheURL = casheURL;
		mesh.sourceURL = sourceURL;
		
		stream.close();
		
		return mesh;
	}
	
	
	private static function encodeFile( file:File )
	{
		var sourceURL:String = getLocalURL(file);
		var casheURL:String = file.name;
		
		switch (file.extension)
		{
			case "obj":
				casheURL = casheURL.substr( 0, casheURL.length - 3) +"mesh";
				new MeshLoader(sourceURL, casheURL, onMeshReady);
			case "png":
				convertToATF(sourceURL, casheURL);
			default:
				trace(file.extension);
		}

		AssetsPanel.getInstance().populate();
	}
	private static function convertToATF( sourceURL:String, casheURL:String )
	{
		var atfTool = File.applicationDirectory.resolvePath("png2atf.exe");
		var args:Vector<String> = new Vector<String>();
		args.push("-c");
		args.push("d");
		args.push("-i");
		args.push(Assets.sourceDirectory.resolvePath(sourceURL).nativePath);
		args.push("-o");
		casheURL = casheURL.substr( 0, casheURL.length - 4);
		args.push(Assets.casheDirectory.resolvePath(casheURL).nativePath + ".atf");
		
		var process:Process = new Process();
		process.startProcess(args, atfTool);
	}
	private static function onMeshReady( mesh:Mesh )
	{
		
		var bytes:ByteArray = new ByteArray();
		
		bytes.writeObject( mesh );
		bytes.position = 0;
		//bytes.compress(CompressionAlgorithm.LZMA);
		
		var casheFile:File = Assets.casheDirectory.resolvePath( mesh.casheURL );
		
		
		var stream = new FileStream();
		
		stream.open(casheFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
	}
	
	public static function DeleteFile( file:File )
	{
		if (file.isDirectory)
			file.deleteDirectory(true);
		else
			file.moveToTrash();
		
		AssetsPanel.getInstance().populate();

	}
	public static function NewMaterial()
	{
		var newMaterial:File =  AssetsPanel.currentDirectory.resolvePath("material.mat");
		var i:UInt = 1;
		while( newMaterial.exists )
		{
			newMaterial = AssetsPanel.currentDirectory.resolvePath("material "+i+".mat");
			i++;
		}
		
		var sourceURL:String = getLocalURL(newMaterial);
		var casheURL:String = newMaterial.name;
		
		var material:Material = new Material(sourceURL, casheURL);
		material.shaderURL = "shaders/UnlitShader.hx";
		material.init();
		
		IO.WriteMaterial( material );

		Assets.materials.push(material);
		AssetsPanel.getInstance().populate();
	}
	
	private inline static function getLocalURL(file:File):String
	{
		return StringTools.urlDecode(file.url.substring(Assets.sourceDirectory.url.length+1));
	}
	
	public static function NewFolder()
	{
		var newFolder:File =  AssetsPanel.currentDirectory.resolvePath("New Folder");
		var i:UInt = 1;
		while( newFolder.exists )
		{
			newFolder = AssetsPanel.currentDirectory.resolvePath("New Folder "+i);
			i++;
		}
		newFolder.createDirectory();
		AssetsPanel.getInstance().populate();
	}
	
}