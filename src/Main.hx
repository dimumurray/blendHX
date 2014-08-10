package;
import blendhx.editor.Selection;

import blendhx.editor.*;
import blendhx.editor.panels.*;
import blendhx.editor.spaces.*;
import blendhx.editor.uicomponents.*;
import blendhx.core.*;
import blendhx.core.assets.*;
import blendhx.core.systems.*;
import blendhx.core.components.*;

import flash.system.Capabilities;
import flash.desktop.NativeApplication;
import flash.display.StageAlign;
import flash.filesystem.File;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;

class Main extends Entity
{
    var stage:Stage;
    var scene:Scene;
    var renderingSystem:RenderingSystem;

    public static function main()
    {
    	new Main();
    }

    public function new()
    {
		
    	RegisterClassAlias.Register();
    	super();
    	initStage();
		loadProject();
    	initSpaces();
    	initRenderingSystem();
    	scene = Scene.getInstance();
		Selection.Initialize();
    }
	
	private function loadProject()
	{
		Assets.SetProjectDirectory( File.desktopDirectory.resolvePath("NewProject") );
	}

    function initStage()
    {
    	stage = flash.Lib.current.stage;
    	stage.scaleMode = StageScaleMode.NO_SCALE;
    	stage.align = StageAlign.TOP_LEFT;
    	stage.addEventListener(Event.RESIZE, onApplicationResize);
    }

    function initSpaces():Void
    {
		
    	var rightSpace:Space = Space.GetSpace(Space.PROPERTIES);
    	
    	var leftSpace:Space = Space.GetSpace(Space.HIERARCHY);
		var bottomSpace:Space = Space.GetSpace(Space.BOTTOM);
    	var viewportSpace:Space = Space.GetSpace(Space.VIEWPORT);
    	
		var topSpace:Space = Space.GetSpace(Space.HEADER);
		
    	var hierarchyPanel:HierarchyPanel = HierarchyPanel.getInstance();
		
    	leftSpace.addPanel(hierarchyPanel);
		
		
		Space.Resize();
    }

    function initRenderingSystem():Void
    {
    	renderingSystem = RenderingSystem.getInstance();
    	renderingSystem.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
    	renderingSystem.init();
    }

    function onContext3DCreate(_):Void
    {
    	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    	Scene.getInstance().initilize();
		HierarchyPanel.getInstance().populate();
		Space.Resize();
    	loadAssets();
    }

    function loadAssets():Void
    {
    	Assets.onAssetsReady = onAssetsReady;
    	Assets.Load();
    }

    function onAssetsReady():Void
    {
		Scene.getInstance().createDefaultSceneObjects();
		HierarchyPanel.getInstance().populate();
	}

    function onApplicationResize(e:Event)
    {
    	Space.Resize();
    }

    function onEnterFrame(_):Void
    {
		if(scene.isEditMode() )
			scene.editorObjects.update();
		else 
			scene.playModeSceneObjects.update();

    	renderingSystem.update();
    }
}
