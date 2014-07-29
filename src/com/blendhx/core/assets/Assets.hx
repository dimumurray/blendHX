package com.blendhx.core.assets;
import shaders.UnlitShader;
import haxe.xml.Fast;

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
	private static var numTexturesReady:Int = 0;
	private static var numMeshesLeftLoading:Int = 2;
	public static var onAssetsReady:Void->Void;
	public static var onMeshesReady:Void->Void;
	public static var projectDirectory:File;
	public static var sourceDirectory:File;
	public static var casheDirectory:File;
	
	
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
		var xml = Xml.parse(e.target.data);
		var fast = new Fast(xml.firstElement());

	 	loadTextures( fast.node.textures );
		loadMeshes( fast.node.meshes );
		loadMaterials( fast.node.materials );
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
		
		}

		Debug.Log("Materials loaded: " + materials.length);
	}

	private static function loadMeshes(meshesXML:Fast)
	{
		var mesh:Mesh;
		
		numMeshesLeftLoading = meshesXML.nodes.mesh.length;
		for( meshXML in meshesXML.nodes.mesh ) 
		{
			var localURL:String = meshXML.att.localURL;
			var casheURL:String = meshXML.innerData;
			
			mesh = IO.LoadMesh(localURL, casheURL);
			mesh.uploadBuffers();
			meshes.push(mesh);
		}


		Debug.Log("Meshes loaded: " + meshes.length);
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
		numTexturesReady ++;
		
		if (numTexturesReady == textures.length)
		{
			Debug.Log("Textures loaded: " + textures.length);
			if(onAssetsReady != null)onAssetsReady();
		}
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