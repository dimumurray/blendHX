package com.blendhx.editor.panels;
import flash.system.ApplicationDomain;
import flash.Lib;

import com.blendhx.editor.Selection;
import com.blendhx.core.components.Component;
import com.blendhx.core.components.Camera;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.spaces.Space;
import com.blendhx.editor.assets.FileType;
import com.blendhx.editor.data.UserScripts;


class AddComponentPanel extends Panel
{
	var className:ObjectInput;
	
    public function new()
    {
    	super("Add Script", Space.SPACE_WIDTH);
    	new Label("Script file:", 1, 1, 30, this);
		
    	className = new ObjectInput(FileType.SCRIPT, 1, 1, 50, doNothing, this);
		
    	new Button("Add", 1, 1, 80, addComponent, this);
    }

    public function doNothing()
    { }

    public function addComponent()
    {
		if ( className.value == null)
			return;
		
		
		var component:Component = UserScripts.GetComponent( className.value );
		if (component == null)
			return;

    	Selection.GetSelectedEntity().addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
    }
}
