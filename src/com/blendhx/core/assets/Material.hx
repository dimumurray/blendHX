package com.blendhx.core.assets;

import hxsl.Shader;
import shaders.UnlitShader;

/**
* @author 
 */
class Material
{

	public var casheURL:String;
	public var sourceURL:String;
	public var shaderURL:String = "shaders/UnlitShader.hx";
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
		var shaderClassName:String = StringTools.replace(shaderURL, "/", ".");
		shaderClassName = shaderClassName.substring(0, shaderClassName.length - 3);
		
		if(shader == null || Type.getClassName( Type.getClass(shader) ) != shaderClassName)
		{
			shader = Type.createInstance( Type.resolveClass( shaderClassName ), []) ;
			shader.create();
		}

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