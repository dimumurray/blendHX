package com.blendhx.editor.spaces;
import com.blendhx.editor.assets.FileType;


import com.blendhx.core.components.Component;

import com.blendhx.editor.panels.UtilityPanel;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.panels.PanelPool;
import com.blendhx.editor.uicomponents.*;
/**

 * GPL

 */
class PropertiesSpace extends Space
{	
	public function new()
	{
		super();
		
		addPanel( PanelPool.Get( "Utility" ) );
	}
	
	// override to update component panels specific to this space
	override public function resize()
	{
		super.resize();
		
		if ( Selection.isHierarchyItem() )
			populateWithComponentPanels();
		else if ( Selection.isFileItem() )
			populateWithAssetPanels();
		
		
	}
	
	private function populateWithAssetPanels()
	{
		removePanels();
		addPanel( PanelPool.Get( "Utility" ) );
		
		switch (Selection.GetSelectedFileItem().type )
		{
			case FileType.MATERIAL:
				addPanel( PanelPool.Get( "Material" ) );
			default:

		}

	}
	
	private function populateWithComponentPanels()
	{
		removePanels();
		
		var components:Array<Component> = Selection.GetSelectedGameObject().children;
		for (component in components)
		{
			var className:String = Type.getClassName( Type.getClass(component) );
			className = className.substring(className.lastIndexOf(".")+1);
			
			var panel:Panel = PanelPool.Get( className );
			
		
			if(panel != null)
			{
				panel.setEnabled(component.enabled);
				addPanel(panel);
			}
		}
	
		addPanel( PanelPool.Get( "AddComponent" ) );
	}

}