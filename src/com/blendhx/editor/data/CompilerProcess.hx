package com.blendhx.editor.data;

import com.blendhx.core.assets.Assets;
import com.blendhx.editor.data.Process;
import com.blendhx.editor.Debug;
import com.blendhx.editor.Progressbar;
import flash.filesystem.File;
import flash.Vector;

/**

 * GPL

 */
class CompilerProcess
{
	
	public static function Compile():Void
	{
	
		if( Process.getInstance().isRunning() )
		{
			Debug.Log("There is another process running");
			return null;
		}
		
		var file:File = Assets.projectDirectory.resolvePath( "compile.cmd" );
		
		var args:Vector<String> = new Vector<String>();
		args.push(Assets.projectDirectory.nativePath);
		Progressbar.getInstance().show(true, "Compiling");
		
		var process:Process = Process.getInstance();
		process.startProcess(args, file);
	}
}