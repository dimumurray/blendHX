package com.blendhx.editor.panels;
import flash.system.ApplicationDomain;
import flash.Lib;
import scripts.*;

import com.blendhx.editor.Selection;
import com.blendhx.core.components.Component;
import com.blendhx.core.components.Camera;
import shaders.UnlitShader;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.spaces.Space;
import com.blendhx.editor.assets.FileType;

class AddComponentPanel extends Panel
{
    public function new()
    {
    	super("Add Script", Space.SPACE_WIDTH);
    	new Label("Script Name:", 1, 1, 30, this);
		
    	new ObjectInput(FileType.SCRIPT, 1, 2, 50, doNothing, this);
		
    	new Button("Add", 2, 2, 50, addComponent, this);
    }

    public function doNothing()
    { }

    public function addComponent()
    {
		var componentClass:Class<Dynamic> = Type.resolveClass("scripts.TransformJiggle");
		if(componentClass == null)
		{
			Debug.Log("Script defenition not found. Consider re compiling");
			return;
		}
			
    	var component:Component = Type.createInstance(componentClass, []);
		if(component == null)
		{
			Debug.Log("Only scripts that are extending com.blendhx.Component can be added");
			return;
		}
		
    	Selection.GetSelectedGameObject().addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
    }
}
