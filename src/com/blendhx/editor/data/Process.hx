package com.blendhx.editor.data;

import flash.desktop.NativeApplication;
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.desktop.NativeApplication;
import flash.errors.ArgumentError;
import flash.errors.Error;
import flash.events.ProgressEvent;
import flash.events.NativeProcessExitEvent;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.events.Event;

import flash.filesystem.File;
import flash.display.Stage;
import flash.desktop.NotificationType;
import flash.Vector;

class Process extends EventDispatcher
{
	public var process:NativeProcess;
	public var name:String;

	public function new()
	{
		super();
		process = new NativeProcess();
		process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onProcessOutputData);
		process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onProcessErrorData);
		process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
	}
	public function startProcess(args:Vector<String>, file:File)
	{

		var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		nativeProcessStartupInfo.arguments = args;
		nativeProcessStartupInfo.executable = file;


		try 
		{
			Debug.Log("starting process");
			process.start(nativeProcessStartupInfo);
		} catch (e:IllegalOperationError) {
			Debug.Log("Illegal Operation: " + e.toString());
		} catch (ae:ArgumentError) {
			Debug.Log("Argument Error: " + ae.toString());
		} catch (e:Error) {
			Debug.Log("Try Error: " + e.toString());
		}
	}
	
	public function onProcessExit(e:NativeProcessExitEvent):Void
	{
		NativeApplication.nativeApplication.activeWindow.notifyUser(NotificationType.INFORMATIONAL);
		//dispatchEvent(new Event(AntivirusEvent.SCAN_EXIT));
		Debug.Log("onProcessExit code: "+e.exitCode);
	}

	public function onProcessOutputData(e:ProgressEvent):Void
	{
		Debug.Log("onProcessOutputData: "+process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
	}

	public function onProcessErrorData(e:ProgressEvent):Void
	{
		try
		{
			NativeApplication.nativeApplication.activeWindow.notifyUser(NotificationType.CRITICAL);
		}
		catch(e:Dynamic)
		{
			
		}
		var errorData:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
		Debug.Log("process error:"+errorData);
	}

	public function isRunning():Bool
	{
		return process.running;
	}

	public function exit():Void
	{
		if(process.running)
			process.exit(true);
	}
}
