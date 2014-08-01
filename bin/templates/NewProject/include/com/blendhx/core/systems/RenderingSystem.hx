package com.blendhx.core.systems;

import com.blendhx.core.assets.Mesh;
import com.blendhx.core.components.*;
import com.blendhx.editor.Debug;
import com.blendhx.core.shaders.DefaultShader;

import hxsl.Shader;

import flash.events.ErrorEvent;
import flash.errors.Error;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3D;
import flash.display.Stage3D;
import flash.display.Stage;
import flash.display3D.Context3DBlendFactor;
import flash.Lib;
import flash.system.ApplicationDomain;


/**
* @author 
 */
class RenderingSystem extends EventDispatcher implements ISystem
{
	private static var instance:RenderingSystem;
	
	public var context3D:Context3D;
	public var camera:Camera;
	
	private var meshRenderers:Array<MeshRenderer>;
	private var transforms:Array<Transform>;
	private var meshes:Array<Mesh>;
	private var shaders:Array<Shader>;
	private var defaultShader:DefaultShader;
	private var shaderError:String;

	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new RenderingSystem();
      	else
          return instance;
  	}
	
	public function new() 
	{
		super();
		
		defaultShader = new DefaultShader();
		defaultShader.create(ApplicationDomain.currentDomain);
		meshRenderers = new Array<MeshRenderer>();
		transforms = new Array<Transform>();
		meshes = new Array<Mesh>();
		shaders = new Array<Shader>();
	}
	
	public function init()
	{
		Lib.current.stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, initContext3D);
		Lib.current.stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, context3DError);
		Lib.current.stage.stage3Ds[0].requestContext3D();
	}
	private function context3DError(e:ErrorEvent)
	{
		Debug.Log(e.text);
	}
	
	private function initContext3D(e:Event)
	{
		context3D = Lib.current.stage.stage3Ds[0].context3D;
		context3D.enableErrorChecking = true;
		context3D.configureBackBuffer(640, 480, 4, true);
		context3D.setDepthTest( true, Context3DCompareMode.LESS_EQUAL );
		context3D.setCulling(Context3DTriangleFace.BACK);
		context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		context3D.addEventListener(ErrorEvent.ERROR, onError);
		dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
	}
	private function onError(e:ErrorEvent)
	{
		Debug.Log(e.text);
	}
	public function update() 
	{
		if(context3D==null) return;
		
		var transform:Transform;
		var mesh:Mesh;
		var shader:Shader;
		
		context3D.clear(0.22, 0.22, 0.22, 1.0);
		
		for (meshRenderer in meshRenderers)
		{
			transform = meshRenderer.transform;
			mesh = meshRenderer.mesh;
			 
			if(meshRenderer.enabled == false)
				continue;
			if(mesh == null)
				continue;
			if(meshRenderer.material == null)
				shader = defaultShader;
			else
				shader = meshRenderer.material.shader;
			
			shader.updateMatrix(transform.matrix, camera.getViewProjection());
			shader.bind(context3D, mesh.vertexBuffer);
			try
			{
				context3D.drawTriangles(mesh.indexBuffer);
			}
			catch(e:Error)
			{
				if (shaderError != e.message)
				{
					shaderError = e.message;
					Debug.Log(shaderError);
				}

				
				//fallback
				shader.unbind(context3D);
				shader = defaultShader;
				shader.updateMatrix(transform.matrix, camera.getViewProjection() );
				shader.bind(context3D, mesh.vertexBuffer);
				context3D.drawTriangles(mesh.indexBuffer);
			}
				
			shader.unbind(context3D);
		}
		context3D.present(); 
	}

	public function registerMeshRenderer(meshRenderer:MeshRenderer) 
	{
		meshRenderers.push(meshRenderer);
	}

	public function unregisterMeshRenderer(meshRenderer:MeshRenderer) 
	{
		for(m in meshRenderers)
			if(m == meshRenderer)
				meshRenderers.remove(m);
	}
}