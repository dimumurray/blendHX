package;

import com.blendhx.editor.*;
import com.blendhx.editor.panels.*;
import com.blendhx.editor.spaces.*;
import com.blendhx.editor.uicomponents.*;
import com.blendhx.core.*;
import com.blendhx.core.assets.*;
import com.blendhx.core.systems.*;
import com.blendhx.core.components.*;

import flash.system.Capabilities;
import flash.desktop.NativeApplication;
import flash.display.StageAlign;
import flash.filesystem.File;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;

class Main extends GameObject
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
    	Scene.getInstance().init();
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
    	scene.update();
    	renderingSystem.update();
    }
}
