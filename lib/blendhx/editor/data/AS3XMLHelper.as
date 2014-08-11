package blendhx.editor.data
{

	public class AS3XMLHelper
	{
		public static function GetAssetsLength( xmlString:String):int
		{
			var myXML:XML = new XML( xmlString );
			return myXML.materials.material.length() + myXML.meshes.mesh.length() + myXML.textures.texture.length();
		}
		
		public static function Remove( xmlString:String, sourceURL:String ):String
		{
			var myXML:XML = new XML( xmlString );
			for(var i:int=0; i<myXML.materials.material.length(); i++)
				if( myXML.materials.material[i].@localURL == sourceURL)
					delete myXML.materials.material[i];
					
			for(i=0; i<myXML.meshes.mesh.length(); i++)
				if( myXML.meshes.mesh[i].@localURL == sourceURL)
					delete myXML.meshes.mesh[i];
					
			for(i=0; i<myXML.textures.texture.length(); i++)
				if( myXML.textures.texture[i].@localURL == sourceURL)
					delete myXML.textures.texture[i];
					
			return myXML.toString();
		}
		public static function MoveAssetInXML( xmlString:String, sourceURL:String, newURL:String ):String
		{
			var myXML:XML = new XML( xmlString );
			for each( var material:XML in myXML.materials.material )
			{
				if( material.@localURL == sourceURL )
				{
					material.@localURL = newURL;
					return myXML.toString();
				}
			}
			for each( var texture:XML in myXML.textures.texture )
			{
				if( texture.@localURL == sourceURL )
				{
					texture.@localURL = newURL;
					return myXML.toString();
				}
			}
			for each( var mesh:XML in myXML.meshes.mesh )
			{
				if( mesh.@localURL == sourceURL )
				{
					mesh.@localURL = newURL;
					return myXML.toString();
				}
			}
			
			return myXML.toString();
		}
		
		public static function AddMaterial(xmlString:String, sourceURL:String, casheURL:String ):String
		{
			var myXML:XML = new XML( xmlString );
			var newMaterial:XML = new XML( "<material>"+casheURL+"</material>"  );
			newMaterial.@localURL = sourceURL;
			
			myXML.materials.appendChild( newMaterial );
			return myXML.toString();
		}
		
		public static function AddTexture(xmlString:String, sourceURL:String, casheURL:String, width:int, height:int ):String
		{
			var myXML:XML = new XML( xmlString );
			var newTexture:XML = new XML( "<texture>"+casheURL+"</texture>"  );
			newTexture.@localURL = sourceURL;
			newTexture.@width = width;
			newTexture.@height = height;
			
			myXML.textures.appendChild( newTexture );
			return myXML.toString();
		}
		
		public static function AddMesh(xmlString:String, sourceURL:String, casheURL:String ):String
		{
			var myXML:XML = new XML( xmlString );
			var newMesh:XML = new XML( "<mesh>"+casheURL+"</mesh>"  );
			newMesh.@localURL = sourceURL;
			
			myXML.meshes.appendChild( newMesh );
			return myXML.toString();
		}
	}
}