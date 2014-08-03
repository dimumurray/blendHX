package com.blendhx.editor.spaces;
import com.blendhx.editor.panels.Panel;
import com.blendhx.editor.assets.FileType;


import com.blendhx.core.components.Component;

import com.blendhx.editor.panels.UtilityPanel;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.panels.PanelPool;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.editor.data.AS3DefinitionHelper;

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
		
		var components:Array<Component> = Selection.GetSelectedEntity().children;
		for (component in components)
		{
			var className:String = "";
			try
			{
				className = AS3DefinitionHelper.getClassName(component);
			}
			catch(e:Dynamic)
			{}
				
			className = className.substring(className.lastIndexOf("::")+2);
			
			var panel:Panel = PanelPool.Get( className );
			
		
			if(panel != null)
			{
				panel.hostComponent = component;
				panel.setEnabled(component.enabled);
				addPanel(panel);
			}
		}

		addPanel( PanelPool.Get( "AddComponent" ) );
	}

}