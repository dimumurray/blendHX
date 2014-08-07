package blendhx.editor.panels;

import blendhx.editor.panels.*;
import blendhx.editor.spaces.Space;

/**

 * GPL

 */
class PanelPool
{
	private static var panels:Map<String,Panel>;

	public static function Get( name:String ):Panel
	{
		if(name == "Entity")
			return null;
		
		if( panels == null)
		{
			panels = new Map<String,Panel>();
			panels.set("Transform", new TransformPanel() );
			panels.set("Camera", new CameraPanel() );
			panels.set("MeshRenderer", new MeshRendererPanel() );
			panels.set("Material", new MaterialPanel() );
			panels.set("AddComponent", new AddComponentPanel() );
			panels.set("Utility", new UtilityPanel() );
			panels.set("Panel", new Panel("Empty", Space.SPACE_WIDTH ) );
		}
		
		if ( !panels.exists(name) )
			panels.set( name, new ComponentPanel(name) );
			
		return panels.get( name );
	}	
}