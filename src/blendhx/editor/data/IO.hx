package blendhx.editor.data;

import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.utils.Endian;
import openfl.Vector;
import openfl.utils.CompressionAlgorithm;
import openfl.filesystem.File;
import openfl.filesystem.*;
import openfl.utils.ByteArray;
import openfl.net.FileReference;
import openfl.events.Event;

import blendhx.core.assets.TextureLoader;
import blendhx.core.assets.Mesh;
import blendhx.core.assets.Assets;
import blendhx.core.assets.MeshLoader;
import blendhx.core.assets.Material;
import blendhx.editor.panels.AssetsPanel;
import blendhx.editor.data.Process;
import hxsl.Shader;
import haxe.ds.StringMap;

/**

 * GPL

 */
class IO
{
	public function new() 
	{
		
	}
	
	public static function DeleteCasheFile( casheURL:String )
	{
		var casheFile:File =  Assets.casheDirectory.resolvePath( casheURL );
		if (casheFile.exists)
			casheFile.moveToTrash();

	}
	
	public static function DeleteFile( file:File )
	{
		if (file.isDirectory)
			file.deleteDirectory(false);
		else
			file.moveToTrash();
		
		
		var newXMLString:String =  blendhx.editor.data.AS3XMLHelper.Remove(Assets.xml.toString(), getLocalURL( file ) );
		Assets.xml = Xml.parse( newXMLString );
		IO.WriteXML(Assets.xml); 
		
		Assets.RemoveAsset(getLocalURL( file ));
			
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
		var casheURL:String = getUniqueCasheName("material", "data");
		
		var material:Material = new Material(sourceURL, casheURL);
		material.shaderURL = "shaders/UnlitShader.hx";
		material.init();
		
		IO.WriteMaterial( material );

		Assets.materials.push(material);
		AssetsPanel.getInstance().populate();
		
		var newXMLString:String =  blendhx.editor.data.AS3XMLHelper.AddMaterial(Assets.xml.toString(), sourceURL, casheURL);
		Assets.xml = Xml.parse( newXMLString );
		IO.WriteXML(Assets.xml);
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
	public static function NewShader()
	{
		var newShader:File =  AssetsPanel.currentDirectory.resolvePath("Shader.hx");
		var i:UInt = 1;
		while( newShader.exists )
		{
			newShader = AssetsPanel.currentDirectory.resolvePath("Shader"+i+".hx");
			i++;
		}
		var templateScript:File = File.applicationDirectory.resolvePath("templates/Shader.hx");
		templateScript.copyTo(newShader);
		AssetsPanel.getInstance().populate();
	}
	public static function NewScript()
	{
		var newScript:File =  AssetsPanel.currentDirectory.resolvePath("Script.hx");
		var i:UInt = 1;
		while( newScript.exists )
		{
			newScript = AssetsPanel.currentDirectory.resolvePath("Script"+i+".hx");
			i++;
		}
		var templateScript:File = File.applicationDirectory.resolvePath("templates/Script.hx");
		templateScript.copyTo(newScript);
		AssetsPanel.getInstance().populate();
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
	
	public static function WriteXML( xml:Xml )
	{		
		var assetsFile:File = Assets.casheDirectory.resolvePath( "assets.xml" );
		
		var stream = new FileStream();
		stream.open(assetsFile, FileMode.WRITE);
		stream.writeUTFBytes( xml.toString() );
		stream.close();
	}
	
	public static function ImportOBJ( file:File )
	{
		var sourceFolderFile:File =  AssetsPanel.currentDirectory.resolvePath(file.name);
		
		if(sourceFolderFile.exists)
		{
			trace("File already exists");
			return;
		}
		file.copyTo(sourceFolderFile);
		
		var sourceURL:String = getLocalURL( sourceFolderFile );
		var casheURL:String = getUniqueCasheName("mesh", "data");
		new MeshLoader(sourceURL, casheURL, onMeshReady);
		
		var newXMLString:String =  blendhx.editor.data.AS3XMLHelper.AddMesh(Assets.xml.toString(), sourceURL, casheURL);
		Assets.xml = Xml.parse( newXMLString );
		IO.WriteXML(Assets.xml);
		
		
		AssetsPanel.getInstance().populate();
	}
	public static function ImportPNG( file:File )
	{
		var sourceFolderFile:File =  AssetsPanel.currentDirectory.resolvePath(file.name);
		
		if(sourceFolderFile.exists)
		{
			trace("File already exists");
			return;
		}
			
		new TexturePropertiesLoader(file, convertToATF);
	}
	
	
	public static function LoadMaterial(sourceURL:String, casheURL:String):Material
	{
		var loadFile:File = Assets.casheDirectory.resolvePath( casheURL );
		
		
		if(!loadFile.exists )
		{
			trace("Material not found: "+loadFile.nativePath);
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
	
	public static function LoadMesh( sourceURL:String, casheURL:String ):Mesh
	{
		var loadFile:File = Assets.casheDirectory.resolvePath( casheURL );
		
		if(!loadFile.exists)
		{
			trace("Mesh not found: "+loadFile.nativePath);
			return null;
		}
		
		
		
		var stream = new FileStream();
		stream.open(loadFile, FileMode.READ);
		var bytes:ByteArray = new ByteArray();
		stream.readBytes(bytes, 0, stream.bytesAvailable );
		bytes.uncompress(CompressionAlgorithm.LZMA);
		var mesh:Mesh = bytes.readObject();
		//var mesh:Mesh = stream.readObject();
		mesh.casheURL = casheURL;
		mesh.sourceURL = sourceURL;
		
		stream.close();
		
		return mesh;
	}
	
	private static function convertToATF( texturePropertiesLoader:TexturePropertiesLoader ):Void
	{
		
		if( Process.getInstance().isRunning() )
		{
			trace("There is another process running");
			return null;
		}
		
		var file:File = texturePropertiesLoader.file;
		var sourceFolderFile:File =  AssetsPanel.currentDirectory.resolvePath(file.name);
		file.copyTo(sourceFolderFile);
		
		var sourceURL:String = getLocalURL( sourceFolderFile );
		var casheURL:String = getUniqueCasheName("texture", "atf");
		
		AssetsPanel.getInstance().populate();
		
		
		var atfTool = File.applicationDirectory.resolvePath("apps/png2atf.exe");
		var args:Vector<String> = new Vector<String>();
		args.push("-c");
		args.push("d");
		args.push("-r");
		args.push("-i");
		args.push(Assets.sourceDirectory.resolvePath(sourceURL).nativePath);
		args.push("-o");
		casheURL = casheURL.substr( 0, casheURL.length - 4);
		args.push(Assets.casheDirectory.resolvePath(casheURL).nativePath + ".atf");
		
		blendhx.editor.Progressbar.getInstance().show(true, "Encoding ATF");
		
		var process:Process = Process.getInstance();
		process.onComplete = textureLoaded;
		process.startProcess(args, atfTool);
		
		var newXMLString:String =  blendhx.editor.data.AS3XMLHelper.AddTexture(Assets.xml.toString(), sourceURL, casheURL+ ".atf", texturePropertiesLoader.width, texturePropertiesLoader.height);
		Assets.xml = Xml.parse( newXMLString );
		IO.WriteXML(Assets.xml);
		
		textureLoader = new TextureLoader( sourceURL, casheURL+ ".atf", texturePropertiesLoader.width, texturePropertiesLoader.height, null);
	}
	static var textureLoader:TextureLoader;
	private static function textureLoaded( )
	{
		textureLoader.load();
		Assets.textures.push( textureLoader );
	}
	
	private static function onMeshReady( mesh:Mesh )
	{
		var bytes:ByteArray = new ByteArray();
		
		bytes.writeObject( mesh );
		bytes.position = 0;
		bytes.compress(CompressionAlgorithm.LZMA);
		
		var casheFile:File = Assets.casheDirectory.resolvePath( mesh.casheURL );
		
		var stream = new FileStream();
		
		stream.open(casheFile, FileMode.WRITE);
		stream.writeBytes( bytes );
		stream.close();
		
		Assets.meshes.push( mesh );
		mesh.uploadBuffers();
	}
	
	
	private static function getUniqueCasheName(prefix:String, extension:String):String
	{
		var newFile:File =  Assets.casheDirectory.resolvePath(prefix+"."+extension);
		var i:UInt = 1;
		while( newFile.exists )
		{
			newFile = Assets.casheDirectory.resolvePath(prefix+i+"."+extension);
			i++;
		}
		return newFile.name;
	}
	
	private inline static function getLocalURL(file:File):String
	{
		return StringTools.urlDecode(file.url.substring(Assets.sourceDirectory.url.length+1));
	}
}
