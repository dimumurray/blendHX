package com.blendhx.core.assets;

import com.blendhx.core.Utils;
import com.blendhx.editor.Debug;
import com.blendhx.editor.data.UserScripts;
import com.blendhx.editor.data.AS3DefenitionHelper;
import hxsl.Shader;

/*
Instance of the classes are accesible by Assets.GetMaterial()
Either loaded from cashe, or created at runtime using IO.NewMaterial()
*/
class Material
{
	public var casheURL:String;
	public var sourceURL:String;
	public var shaderURL:String = "com.blendhx.core.shaders.DefaultShader.hx";
	public var shader:Shader;
	//populated according to shader properties, used by the MaterialPanel in editor
	public var properties:Map<String, Dynamic>;
	
	public function new(sourceURL:String, casheURL:String)
	{
		this.casheURL = casheURL;
		this.sourceURL = sourceURL;
		
		properties = new Map<String, Dynamic>();
	}
	// in material properties panel, values are set into the shader like this
	public function setProperty(propertyName:String, propertyValue:Dynamic)
	{
		properties.set(propertyName, propertyValue);
	}
	
	public function init()
	{
		//get shader defenition from loaded scripts.swf
		checkShader();
		
		updateShaderProperties();
	}
	
	private function checkShader()
	{
		var shaderClassName:String = Utils.GetClassNameFromURL(shaderURL);
		if(shader == null || AS3DefenitionHelper.getClassName(shader)  != shaderClassName)
		{
			shader = UserScripts.GetShader( shaderURL );
		}
	}
	
	//update shader constants
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
		values = null;
	}
	
	public function destroy()
	{
		shader = null;
		properties = null;
	}
}