package com.blendhx.core;

import com.blendhx.core.components.GameObject;
import com.blendhx.core.components.Component;

/**
 * GPL
 */
class Scene extends GameObject
{
	private static var instance:Scene;
	
	public var editorObjects:GameObject;
	public var objects:GameObject;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new Scene();
      	else
          return instance;
  	}	
	
	public function new() 
	{
		super("Scene");
		
		
		editorObjects = new GameObject("Editor");
		addChild(editorObjects);
	}

}