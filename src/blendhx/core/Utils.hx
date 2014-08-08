package blendhx.core;


class Utils
{
    public static function GetClassNameFromURL(url:String):String
    {
    	var className:String = StringTools.replace(url, "/", ".");
    	className = className.substring(0, className.length - 3);
    	return className;
    }
}
