package com.blendhx.core.assets;
import shaders.UnlitShader;
import haxe.xml.Fast;
import com.blendhx.editor.Progressbar;
import com.blendhx.editor.data.IO;
import com.blendhx.editor.Debug;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.display3D.textures.Texture;
import flash.filesystem.File;
import flash.net.URLRequest;
import flash.net.URLLoader;

class Assets
{
	public static var textures:Array<TextureLoader>;
	public static var meshes:Array<Mesh>;
	public static var materials:Array<Material>;
	public static var onAssetsReady:Void->Void;
	public static var onMeshesReady:Void->Void;
	public static var projectDirectory:File;
	public static var sourceDirectory:File;
	public static var casheDirectory:File;
	public static var xml:Xml;
	
	public static function SetProjectDirectory(projectDirectory:File)
	{
		Assets.projectDirectory = projectDirectory ;
		sourceDirectory = projectDirectory.resolvePath("source");
		casheDirectory = projectDirectory.resolvePath("cashe");
	}
	private static function loadCasheXML()
	{
		var ldr:URLLoader = new URLLoader();
		ldr.addEventListener(Event.COMPLETE, loadXMLComplete);
		ldr.addEventListener(IOErrorEvent.IO_ERROR, loadXMLError);	
		ldr.load( new URLRequest( casheDirectory.resolvePath("assets.xml").url ) );
	}
	
	private static function loadXMLComplete(e:Event)
	{
		xml = Xml.parse(e.target.data);
		var fast = new Fast(xml.firstElement());
		var length:UInt=9;
		
		Progressbar.getInstance().show(false, "Loading", onAssetsReady);
		
		Progressbar.getInstance().totalJobs = length;
			
	 	loadTextures( fast.node.textures );
		loadMeshes( fast.node.meshes );
		loadMaterials( fast.node.materials );
		
	}
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
		
		var newXMLString:String =  com.blendhx.editor.data.AS3XMLHelper.MoveAssetInXML(xml.toString(), sourceURL, destinationURL);
		xml = Xml.parse( newXMLString );
		IO.WriteXML(xml);
		//Debug.Log("File "+sourceURL+" is not in assets catalouge! Consider reimporting it.");
		
	}
	
	public static function RemoveAsset(sourceURL:String)
	{
		
		for (material in materials)
			if (material.sourceURL == sourceURL)
				materials.remove(material);
		for (texture in textures)
			if (texture.sourceURL == sourceURL)
				textures.remove(texture);
		for (mesh in meshes)
			if (mesh.sourceURL == sourceURL)
				meshes.remove(mesh);
		
	}

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

	private static function loadXMLError(e:IOErrorEvent)
	{
		trace(e.text);
	}

	public static function init()
	{
		textures = new Array<TextureLoader>();
		meshes = new Array<Mesh>();
		materials = new Array<Material>();
	}
	
	public static function Load() 
	{
		init();
		
		loadCasheXML();
	}
	
	public static function onTextureReady(_)
	{	
		Progressbar.getInstance().jobsDone ++;
	}
	
	
	public static function GetTexture(sourceURL:String):Texture
	{
		for (texture in textures)
		{
			if (texture.sourceURL == sourceURL)
			{
				return texture.texture;
			}

		}
		Debug.Log("Texture " + sourceURL +" not found.");
		return null;

	}

	public static function GetMesh(sourceURL:String):Mesh
	{
		for (mesh in meshes)
		{
			if (mesh.sourceURL == sourceURL)
			{
				return mesh;
			}

		}
	
		Debug.Log("Mesh " + sourceURL +" not found.");

		return null;

	}
		
	public static function GetMaterial(sourceURL:String):Material
	{
		for (material in materials)
		{
			if (material.sourceURL == sourceURL)
			{
				return material;
			}

		}
	
		Debug.Log("Material " + sourceURL +" not found.");
		return null;

	}


}