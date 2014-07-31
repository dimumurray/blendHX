

package com.blendhx.editor.data
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	
	public class AS3DefenitionHelper
	{
		public static function Instantiate( domain:ApplicationDomain, className:String, desiredClass:*  ):*
		{
			try
			{
				var classType:Class = domain.getDefinition(className) as Class;
				return new classType() as desiredClass;
			}
			catch(e:*)
			{
				return null;
			}
			
		}
		
		
		public static function getClass(domain:ApplicationDomain, obj:Object):Class 
		{
			try
			{
				var classType:Class = Class( domain.getDefinition( flash.utils.getQualifiedClassName(obj)));
			}
			catch(e:*)
			{}
			
     		return classType;
  		}
		public static function getClassByName(domain:ApplicationDomain, qualifiedClassName:String):Class 
		{
			try
			{
				var classType:Class = Class( domain.getDefinition( qualifiedClassName ) );
			}
			catch(e:*)
			{}
			
     		return classType;
  		}
		
		public static function ObjectIsOfType( instance:*, desiredClass:*  ):Boolean
		{
			if(instance is desiredClass)
				return true;
			return false;
		}
		public static function getClassName( instance:* ):String
		{
			return flash.utils.getQualifiedClassName(instance);
		}
		
	}
}