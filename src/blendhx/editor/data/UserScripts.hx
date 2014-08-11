package blendhx.editor.data;
import hxsl.Shader;

import flash.utils.ByteArray;
import flash.net.URLLoaderDataFormat;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.SecurityDomain;
import flash.display.LoaderInfo;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.display.Loader;
import flash.filesystem.File;
import flash.Vector;
import flash.events.Event;
import flash.events.IOErrorEvent;

import blendhx.core.Utils;
import blendhx.core.components.Component;
import blendhx.core.assets.Assets;
import blendhx.editor.data.Process;
import blendhx.editor.Progressbar;
import blendhx.editor.data.AS3DefinitionHelper;
import blendhx.core.shaders.DefaultShader;


/**

 * GPL

 */
class UserScripts
{
	
	public static var onScriptsLoaded:Void->Void;
	
	public static var userScriptsDomain:ApplicationDomain = new ApplicationDomain();
	
	public static function Compile():Void
	{
	
		if( Process.getInstance().isRunning() )
		{
			trace("There is another process running");
			return null;
		}
		
		var file:File = Assets.projectDirectory.resolvePath( "compile.cmd" );
		
		var args:Vector<String> = new Vector<String>();
		Progressbar.getInstance().show(true, "Compiling");
		
		var process:Process = Process.getInstance();
		process.onComplete = loadScripts;
		process.startProcess(args, file, Assets.projectDirectory);
	}
	
	public static function loadScripts()
	{	
		var uldr : URLLoader = new URLLoader();
		var request:URLRequest = new URLRequest( Assets.casheDirectory.resolvePath( "scripts.swf" ).nativePath );
		
		uldr.dataFormat = URLLoaderDataFormat.BINARY;
		uldr.addEventListener(Event.COMPLETE, onBytesComplete);
		uldr.addEventListener(IOErrorEvent.IO_ERROR, onScriptsNotFound);
		uldr.load( request );
	}
	private static function onScriptsNotFound(e:IOErrorEvent)
	{
		var uldr : URLLoader = cast (e.target, URLLoader);
		uldr.removeEventListener(Event.COMPLETE, onBytesComplete);
		uldr.removeEventListener(IOErrorEvent.IO_ERROR, onScriptsNotFound);
		
		if ( onScriptsLoaded != null)
			onScriptsLoaded();
		onScriptsLoaded = null;
		
		trace("Problem loading user scripts");
	}

	private static function onBytesComplete(e : Event)
	{
		var uldr : URLLoader = cast (e.target, URLLoader);
		uldr.removeEventListener(Event.COMPLETE, onBytesComplete);
		uldr.removeEventListener(IOErrorEvent.IO_ERROR, onScriptsNotFound);
		
		var bytes : ByteArray = uldr.data;
		var loader:Loader = new Loader();
		var ldrC : LoaderContext = new LoaderContext();
		userScriptsDomain = new ApplicationDomain(  ApplicationDomain.currentDomain );
		
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, scriptsLoaded);
		ldrC.applicationDomain = userScriptsDomain;
		ldrC.allowCodeImport = true;
		loader.loadBytes(bytes, ldrC);
		
		uldr.data = null;
		uldr = null;
	}

	private static function scriptsLoaded( e:Event )
	{
		cast (e.target, LoaderInfo).loader.removeEventListener(Event.COMPLETE, scriptsLoaded);
		
		registerClassAliases();
			
		if ( onScriptsLoaded != null)
			onScriptsLoaded();
		onScriptsLoaded = null;
	}
	
	public static function GetComponent( classURL:String ):Component
	{
		var componentClass:Class<Dynamic> = userScriptsDomain.getDefinition( Utils.GetClassNameFromURL( classURL ) ); 
		if(componentClass == null)
		{
			trace("Script definition not found. Consider re compiling");
			return null;
		}
		else if(Type.getSuperClass(componentClass) != Component)
		{
			trace("Applied script is not extending blendhx.Component");
			return null;
		}
		
		var className:String = Utils.GetClassNameFromURL( classURL );
		var component:Component = cast(AS3DefinitionHelper.Instantiate(userScriptsDomain, className, Component), Component);
		
		return component;
	}
	
	public static function GetShader( classURL:String ):Shader
	{
		var className:String = Utils.GetClassNameFromURL( classURL );
		var shader:Shader;
		
		shader =  cast(AS3DefinitionHelper.Instantiate(userScriptsDomain, className, Shader), Shader);
		
		if(shader == null)
		{
			shader = new DefaultShader();
			shader.create(ApplicationDomain.currentDomain);
		}
		else
		{
			shader.create(userScriptsDomain);
		}
		
		return shader;
	}
	
	private static function registerClassAliases():Void
	{
		var classNames:Vector<String> = UserScripts.userScriptsDomain.getQualifiedDefinitionNames();
		for(className in classNames)
		{
			var theClass = UserScripts.userScriptsDomain.getDefinition(className);
			var baseClass = Type.getSuperClass( theClass );
			if( Std.string(baseClass) == "[class Component]" || Std.string(baseClass) == "[class Shader]")
			{
				haxe.remoting.AMFConnection.registerClassAlias(className, theClass);
			}
		}
	}
}