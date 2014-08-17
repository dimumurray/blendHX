package blendhx.editor.panels;
import openfl.Lib;
import blendhx.editor.data.UserScripts;
import blendhx.core.Utils;

import blendhx.core.components.Component;
import blendhx.editor.uicomponents.UIElement;
import blendhx.editor.uicomponents.TextInput;
import blendhx.core.assets.Assets;
import blendhx.editor.uicomponents.ObjectInput;
import blendhx.editor.uicomponents.*;
import blendhx.editor.spaces.Space;
import blendhx.editor.assets.FileType;
import blendhx.editor.Selection;
import blendhx.editor.uicomponents.*;
import blendhx.editor.spaces.Space;

import haxe.rtti.Meta;
/**

 * GPL

 */
class ComponentPanel extends Panel
{
	private var hostComponentProperties:Array<String> = [];
	private var property_inputs:Array<UIElement> = [];
	
	public function new(title:String) 
	{
		super(title, Space.SPACE_WIDTH, true);
		//addEventListener(openfl.events.Event.ENTER_FRAME, getValues);
		
	}
	
	
	public function createInputs()
	{
		for (input in property_inputs)
		{
			removeUIElement(input);
			_height = 0;
		}
		property_inputs = [];
	
		hostComponentProperties = getMetaDataProperties();

		var length:Int = Std.int( hostComponentProperties.length / 2 );
		var input_y:Int = 30;
		var input:UIElement;
		
		for (i in 0...length)
		{
			input = new Label(hostComponentProperties[i*2]+":", 1, 2, input_y, this);
			property_inputs.push(input);
	
			switch ( hostComponentProperties[ (i*2) +1] )
			{
				case "Float":
					input = new NumberInput(hostComponentProperties[i*2], 2, 2, input_y, setValues, this, NumberInput.ROUND_BOTH);
				case "Entity":
					input = new ObjectInput(FileType.ENTITY, 2, 2, input_y, setValues, this);
				case "Color":
					input = new TextInput( "0xffffffff", 2, 2, input_y, setValues, this);
				case "String":
					input = new TextInput( "text", 2, 2, input_y, setValues, this);
				default:
					input = new TextInput( "UNKNOWN_INPUT",2, 2, input_y, setValues, this);
			}
			input_y += 30;
			property_inputs.push(input);
		}
	}
	
	//helper function to create editor properties out of meta data tags attached to the host component
	private function getMetaDataProperties():Array<String>
	{
		var properties:Array<String> = [];
		var classDef:Class<Dynamic> = blendhx.editor.data.AS3DefinitionHelper.getClass(UserScripts.userScriptsDomain, hostComponent);
		if(classDef != null)
		{

			var editor = Meta.getFields(classDef);
			var editorString = Std.string( editor );

			var editorObjects = editorString.split(", ");

			for (s in editorObjects)
			{
				s = StringTools.replace(s, "{ ", "");
				var fieldName = s.substring(0, s.indexOf(" : "));
				var fieldType = s.substring(s.lastIndexOf(" : [")+4, s.lastIndexOf("]"));
				properties.push(fieldName);
				properties.push(fieldType);
			}
		}
		return properties;
	}
	 
	
	public function setValues()
	{
		
		if (parent == null || hostComponent==null )
			return;
		
		var propertieslength:Int = Std.int( property_inputs.length / 2 );
		var length:Int = Std.int( hostComponentProperties.length / 2 );
		
		//when inputs are created, this is called unfairly, that shouldnt. we wont resume when loop at createInputs is still running
		if( length != propertieslength)
			return;
			
		for (i in 0...length)
		{
			var value = property_inputs[ (i*2) +1].value;
			hostComponent.properties.set( hostComponentProperties[i*2] , value );
			Reflect.setField(hostComponent, hostComponentProperties[i*2], value);
		}

		
	}


	private function getValues(_)
	{
		trace("get");
		if (parent == null || hostComponent==null )
			return;

		var length:Int = Std.int( property_inputs.length / 2 );
		for (i in 0...length)
		{
			var value = hostComponent.properties.get( hostComponentProperties[i*2] );
			property_inputs[i*2+1].value = value;
		}
	}

	override public function resize()
	{
		if ( parent == null || hostComponent == null)
			return;
		
		super.resize();
		//call these more expensive methods only if there has been a change in the host component
		if( hasHostComponentChanged() )
		{
			createInputs();
			getValues(null);
		}
		
	}

	
}
