package com.blendhx.core.assets;
import com.blendhx.editor.Debug;

import hxsl.Shader;
import com.blendhx.editor.data.UserScripts;
import com.blendhx.editor.data.AS3DefenitionHelper;
/**
* @author 
 */
class Material
{

	public var casheURL:String;
	public var sourceURL:String;
	public var shaderURL:String = "com.blendhx.core.shaders.DefaultShader.hx";
	public var shader:Shader;
	public var properties:Map<String, Dynamic>;
	
	public function new(sourceURL:String, casheURL:String)
	{
		this.casheURL = casheURL;
		this.sourceURL = sourceURL;
		
		properties = new Map<String, Dynamic>();
	}
	
	public function setProperty(propertyName:String, propertyValue:Dynamic)
	{
		properties.set(propertyName, propertyValue);
	}
	
	public function init()
	{
		checkShader();
		
		updateShaderProperties();
	}
	private function checkShader()
	{
		var shaderClassName:String = GetClassNameFromURL(shaderURL);
		if(shader == null || AS3DefenitionHelper.getClassName(shader)  != shaderClassName)
		{
			shader = UserScripts.GetShader( shaderURL );
		}
	}
	
	private function GetClassNameFromURL(url:String):String
	{
		var className:String = StringTools.replace(url, "/", ".");
		className = className.substring(0, className.length - 3);
		return className;
	}
	

	private function updateShaderProperties()
	{
			
		var values:Array<Dynamic> = [];
		var value:Dynamic;
		var length:Int = Std.int( shader.editorProperties.length / 2 );
		
		for (i in 0...length)
		{
			 
			switch ( shader.editorProperties[ (i*2) +1] )
			{
				case "Texture":
					value = Assets.GetTexture( properties.get( shader.editorProperties[i*2] ) );
				case "Color":
					value = properties.get( shader.editorProperties[i*2] );
				default:
					value = null;

			}
			
			values.push(value);
		}
		
		shader.updateProperties(values);
	}
}