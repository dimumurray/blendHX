package blendhx.core.assets;

import haxe.xml.Fast;

import blendhx.editor.Progressbar;
import blendhx.editor.data.IO;
import blendhx.editor.data.UserScripts;

import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.display3D.textures.Texture;
import openfl.utils.ByteArray;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import openfl.system.SecurityDomain;
import openfl.system.ApplicationDomain;
import openfl.system.LoaderContext;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.filesystem.File;


class Assets
{
	//repository of GPU uploaded assets
	public static var textures:Array<TextureLoader> = new Array<TextureLoader>();
	public static var meshes:Array<Mesh> = new Array<Mesh>();
	public static var materials:Array<Material> = new Array<Material>();
	//callback function on asset load on startup, used by main class, so it can then construct scene once after assets are loaded into GPU buffer
	public static var onAssetsReady:Void->Void;
	//used application wide
	public static var projectDirectory:File;
	public static var sourceDirectory:File;
	public static var casheDirectory:File;
	//xml containting asset url addresses and properties
	public static var xml:Xml;
	
	//called by Main class on startup
	public static function SetProjectDirectory(projectDirectory:File)
	{
		// used by the rest of the application
		Assets.projectDirectory = projectDirectory ;
		sourceDirectory = projectDirectory.resolvePath("source");
		casheDirectory = projectDirectory.resolvePath("cashe");
	}
	
	//load assets
	public static function Load() 
	{
		UserScripts.onScriptsLoaded = loadCasheXML;
		UserScripts.loadScripts();
	}
	
	//called after the scripts.swf is loaded by UserScripts
	private static function loadCasheXML()
	{
		var ldr:URLLoader = new URLLoader();
		ldr.addEventListener(Event.COMPLETE, loadXMLComplete);
		ldr.addEventListener(IOErrorEvent.IO_ERROR, loadXMLError);	
		ldr.load( new URLRequest( casheDirectory.resolvePath("assets.xml").url ) );
	}
	
	//On error, the user is in hude trouble
	private static function loadXMLError(e:IOErrorEvent)
	{
		var ldr:URLLoader = cast(e.target, URLLoader);
		ldr.removeEventListener(Event.COMPLETE, loadXMLComplete);
		ldr.removeEventListener(IOErrorEvent.IO_ERROR, loadXMLError);
		ldr = null;
		trace("Critical Error. assets.xml is not found. Ask for help through website", 0xff0000);
		trace(e.text, 0xff0000);
	}
	
	
	private static function loadXMLComplete(e:Event)
	{
		xml = Xml.parse(e.target.data);
		var fast = new Fast(xml.firstElement());
		var length:UInt= blendhx.editor.data.AS3XMLHelper.GetAssetsLength( xml.toString() );
		
		//show the progressbar untill everything is laoded
		Progressbar.getInstance().show(false, "Loading", onAssetsReady);
		Progressbar.getInstance().totalJobs = length;
		
		//load cashe files into Assets
	 	loadTextures( fast.node.textures );
		loadMeshes( fast.node.meshes );
		loadMaterials( fast.node.materials );
		
		//the xml loader cleanup
		var ldr:URLLoader = cast(e.target, URLLoader);
		ldr.removeEventListener(Event.COMPLETE, loadXMLComplete);
		ldr.removeEventListener(IOErrorEvent.IO_ERROR, loadXMLError);
		ldr.data = null;
		ldr = null;
	}
	
	//load textures binary and upload them to GPU one by one
	private static function loadTextures(texturesXML:Fast)
	{
		var textureLoader:TextureLoader;
		
		for( textureXML in texturesXML.nodes.texture ) 
		{
			var width:UInt = Std.parseInt(textureXML.att.width);
			var height:UInt = Std.parseInt(textureXML.att.height);
			var localURL:String = textureXML.att.localURL;
			var casheURL:String = textureXML.innerData;
		
			textureLoader = new TextureLoader( localURL, casheURL, width, height, onTextureReady);
			textureLoader.load();
			Assets.textures.push( textureLoader );
		}
	}
	
	//load materials serialized objects from cashe
	private static function loadMaterials(materialsXML:Fast)
	{
		var material:Material;
		
		for( materialXML in materialsXML.nodes.material ) 
		{
			
			var localURL:String = materialXML.att.localURL;
			var casheURL:String = materialXML.innerData;
		
			material = IO.LoadMaterial(localURL, casheURL);
			materials.push(material);
			Progressbar.getInstance().jobsDone ++;
		}
	}
		
	//load meshes serialized objects, upload them into GPU
	private static function loadMeshes(meshesXML:Fast)
	{
		var mesh:Mesh;
		
		for( meshXML in meshesXML.nodes.mesh ) 
		{
			var localURL:String = meshXML.att.localURL;
			var casheURL:String = meshXML.innerData;
			
			mesh = IO.LoadMesh(localURL, casheURL);
			mesh.uploadBuffers();
			meshes.push(mesh);
			Progressbar.getInstance().jobsDone ++;
		}
	}
		
	//rename asset localURL in assets.xml, rename asset name in Asset class 
	public static function MoveAsset(sourceURL:String, destinationURL:String)
	{
		for (material in materials)
			if (material.sourceURL == sourceURL)
			material.sourceURL = destinationURL;
		for (texture in textures)
			if (texture.sourceURL == sourceURL)
				texture.sourceURL = destinationURL;
		for (mesh in meshes)
			if (mesh.sourceURL == sourceURL)
				mesh.sourceURL = destinationURL;
		
		var newXMLString:String =  blendhx.editor.data.AS3XMLHelper.MoveAssetInXML(xml.toString(), sourceURL, destinationURL);
		xml = Xml.parse( newXMLString );
		IO.WriteXML(xml);
	}
	
	// remove asset object from Asset
	public static function RemoveAsset(sourceURL:String)
	{
		for (material in materials)
		{
			if (material.sourceURL == sourceURL)
			{
				materials.remove(material);
				material.destroy();
				IO.DeleteCasheFile(material.casheURL);
				return;
			}
		}
		for (texture in textures)
		{
			if (texture.sourceURL == sourceURL)
			{
				textures.remove(texture);
				texture.destroy();
				IO.DeleteCasheFile(texture.casheURL);
				return;
			}
		}
		for (mesh in meshes)
		{
			if (mesh.sourceURL == sourceURL)
			{
				meshes.remove(mesh);
				mesh.destroy();
				IO.DeleteCasheFile(mesh.casheURL);
				return;
			}
		}
	}
	
	
	//push the Progressbar
	public static function onTextureReady()
	{	
		Progressbar.getInstance().jobsDone ++;
	}
	
	
	//finds the texture, once called by a material asset instance
	public static function GetTexture(sourceURL:String):Texture
	{
		for (texture in textures)
		{
			if (texture.sourceURL == sourceURL)
			{
				return texture.texture;
			}
		}

		if(sourceURL != "" && sourceURL != "null")
			trace("Texture " + sourceURL +" not found.", 0xff6600);
		return null;

	}

	//finds the mesh, once called by a meshRenderer component instance
	public static function GetMesh(sourceURL:String):Mesh
	{
		for (mesh in meshes)
		{
			if (mesh.sourceURL == sourceURL)
			{
				return mesh;
			}
		}

		if(sourceURL != "" && sourceURL != "null")
			trace("Mesh " + sourceURL +" not found.", 0xff6600);

		return null;

	}
	
	//finds the material, once called by a meshRenderer component instance
	public static function GetMaterial(sourceURL:String):Material
	{
		for (material in materials)
		{
			if (material.sourceURL == sourceURL)
			{
				return material;
			}
		}

		if(sourceURL != "" && sourceURL != "null")
			trace("Material " + sourceURL +" not found.", 0xff6600);
		return null;

	}


}
