package blendhx.editor.spaces;
import blendhx.editor.panels.Panel;
import blendhx.editor.assets.FileType;


import blendhx.core.components.Component;
import blendhx.editor.panels.*;
import blendhx.editor.panels.PanelPool;
import blendhx.editor.uicomponents.*;
import blendhx.editor.data.AS3DefinitionHelper;

/**

 * GPL

 */
class PropertiesSpace extends Space
{	
	
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
			className = Std.string(component).split(" ")[1];
			className = className.substring(0, className.length - 1);

			var panel:Panel = PanelPool.Get( className );


			if(panel != null)
			{
				panel.hostComponent = cast component;
				panel.enabled = component.enabled;
				addPanel(panel);
			}
		}
	
		

		addPanel( PanelPool.Get( "AddComponent" ) );
	}

}
