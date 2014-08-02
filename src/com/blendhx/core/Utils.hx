package com.blendhx.core;

import flash.system.ApplicationDomain;
import com.blendhx.editor.data.AS3DefinitionHelper;
import com.blendhx.editor.data.UserScripts;

class Utils
{
	public static function GetClassNameFromURL(url:String):String
	{
		var className:String = StringTools.replace(url, "/", ".");
		className = className.substring(0, className.length - 3);
		return className;
	}
	
	public static function GetClassFromAnyDomain(component:Dynamic):Class<Dynamic>
	{
		var classType:Class<Dynamic> = null;
		
		
		var searchingDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		classType = AS3DefinitionHelper.getClass(searchingDomain, component);
		
		if(classType == null)
		{
			searchingDomain = UserScripts.userScriptsDomain;
			classType = AS3DefinitionHelper.getClass(searchingDomain, component);
		}
			
		return classType;
	}
}