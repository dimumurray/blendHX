package blendhx.editor.panels;

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


/**

 * GPL

 */
class ComponentPanel extends Panel
{
	var property_inputs:Array<UIElement> = [];
	
	public function new(title:String) 
	{
		super(title, Space.SPACE_WIDTH, true);
		addEventListener(flash.events.Event.ENTER_FRAME, getValues);
	}
	
	public function createInputs()
	{
		for (input in property_inputs)
		{
			removeUIElement(input);
			_height = 0;
		}
		property_inputs = [];
	
		var editorProperties:Array<String> = hostComponent.editorProperties;
		var length:Int = Std.int( editorProperties.length / 2 );
		var input_y:Int = 30;
		var input:UIElement;
		
		for (i in 0...length)
		{
			input = new Label(editorProperties[i*2]+":", 1, 2, input_y, this);
			property_inputs.push(input);
	
			switch ( editorProperties[ (i*2) +1] )
			{
				case "Float":
					input = new NumberInput(editorProperties[i*2], 2, 2, input_y, setValues, this, NumberInput.ROUND_BOTH);
				case "Entity":
					input = new ObjectInput(FileType.ENTITY, 2, 2, input_y, setValues, this);
				case "Color":
					input = new TextInput( "0xffffff77", 2, 2, input_y, setValues, this);
				case "String":
					input = new TextInput( "text", 2, 2, input_y, setValues, this);
				default:
					input = new TextInput( "UNKNOWN_INPUT",2, 2, input_y, setValues, this);
			}
			input_y += 30;
			property_inputs.push(input);
			getValues(null);
		}
	}
	
	public function setValues()
	{
		if (parent == null || hostComponent==null )
			return;
		
		var propertieslength:Int = Std.int( hostComponent.editorProperties.length / 2 );
		var values:Array<Dynamic> = [];
		var length:Int = Std.int( property_inputs.length / 2 );
		
		//when inputs are created, this is called unfairly, that shouldnt. we wont resume when loop at createInputs is still running
		if( length != propertieslength)
			return;
			
		for (i in 0...length)
		{
			var value = property_inputs[ (i*2) +1].value;
			hostComponent.properties.set( hostComponent.editorProperties[i*2] , value );
			values.push(value);
		}
		var component:Component = cast hostComponent;
		component.updateProperties(values);
	}
	
	
	private function getValues(_) 
	{
		if (parent == null || hostComponent==null )
			return;
		
		var editorProperties:Array<String> = hostComponent.editorProperties;
		var length:Int = Std.int( property_inputs.length / 2 );
		for (i in 0...length)
		{
			 
			var value = hostComponent.properties.get( editorProperties[i*2] );
			property_inputs[i*2+1].value = value;
		}
	}

	override public function resize()
	{
		if ( parent == null || hostComponent == null)
			return;
		
		super.resize();
		createInputs();
		getValues(null);
	}
}