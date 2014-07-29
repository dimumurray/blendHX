package com.blendhx.editor.panels;

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
    	var component:Component = Type.createInstance(Type.resolveClass("com.blendhx.core.components.Camera"), []);
    	component.enabled = false;
    	Selection.GetSelectedGameObject().addChild(component);
		HierarchyPanel.getInstance().populate();
    	Space.Resize();
    }
}
