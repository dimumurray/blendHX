package com.blendhx.editor.uicomponents;


/**
* @author 
 */
class Utils
{
	public static function PrintFloat(f:Float, decimals:Int):String
	{
		var no = Std.string(f).split('.');
		if(no.length>=2)
		{
			var out = no[0] + "." +no[1].substr( 0, decimals );
			return out;
		}
		else
		{
			if(Std.string(f) == "NaN")
				return "0";
			return Std.string(f);
		}
	}	
}