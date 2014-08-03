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
    	if (classType == null) {
    		searchingDomain = UserScripts.userScriptsDomain;
    		classType = AS3DefinitionHelper.getClass(searchingDomain, component);
    	};
    	return classType;
    }

    public static function DeepCopy<T>(v:T):T
    {
    	if (!Reflect.isObject(v)) {
    		return v;
    	} else if (Std.is(v, Array)) {
    		var r = Type.createInstance(Type.getClass(v), []);
    		untyped {
    			for (ii in 0 ... v.length) r.push(DeepCopy(v[ii]));
    		};
    		return r;
    	} else if (Type.getClass(v) == null) {
    		var obj:Dynamic = { };
    		for (ff in Reflect.fields(v)) Reflect.setField(obj, ff, DeepCopy(Reflect.field(v, ff)));
    		return obj;
    	} else {
    		var obj = Type.createEmptyInstance(Type.getClass(v));
    		for (ff in Reflect.fields(v)) Reflect.setField(obj, ff, DeepCopy(Reflect.field(v, ff)));
    		return obj;
    	};
    	return null;
    }
}
