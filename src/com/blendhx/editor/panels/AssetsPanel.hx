package com.blendhx.editor.panels;
import flash.text.TextFieldAutoSize;
import com.blendhx.editor.uicomponents.TextInput;
import com.blendhx.core.assets.Assets;

import flash.errors.IllegalOperationError;
import flash.errors.Error;
import flash.events.ErrorEvent;
import com.blendhx.core.components.Entity;
import com.blendhx.editor.uicomponents.Button;
import com.blendhx.editor.assets.FileType;


import com.blendhx.core.*;
import com.blendhx.editor.spaces.*;
import com.blendhx.editor.panels.*;
import com.blendhx.core.components.*;
import flash.events.Event;
import flash.display.Graphics;
import flash.filesystem.File;

/**
* @author 
 */
class AssetsPanel extends Panel
{
	public static var padding:Float = 20;
	public static var colomnWidth:Float = 300;
	public static var rows:Int = 0;
	public static var colomns:Int = 0;
	
	public static  var currentDirectory:File;
	private static var instance:AssetsPanel;
	
	public var fileItems:Array<FileItem>;
	private var fileItemPool:Array<FileItem>;
	private var renameInput:TextInput;
	private var rightClickedFile:File;
	
	public static inline function getInstance()
  	{
    	if (instance == null)
          return instance = new AssetsPanel();
      	else
          return instance;
  	}	
	public function renameFile(fileItem:FileItem)
	{
		rightClickedFile = AssetsPanel.currentDirectory.resolvePath( fileItem.fileName );
		
		if(renameInput == null)
		{
			renameInput = new TextInput("", 999, 999, 0, removeRenameBox, this);
			elements.remove(renameInput);
		}
	
		addChild(renameInput);
		renameInput.label.autoSize = TextFieldAutoSize.LEFT;
		renameInput.value =  fileItem.fileName ;
		renameInput.onMouseDown(null);
		
		var lastIndex:Int = fileItem.fileName.indexOf(".");
		if(lastIndex <= 0) 
			lastIndex = fileItem.fileName.length;
		
		renameInput.label.setSelection(0, lastIndex);
		renameInput.x = fileItem.x + 18;
		renameInput.y = fileItem.y;
		renameInput._width = AssetsPanel.colomnWidth - 30;
		renameInput.resize();
	}
	public function removeRenameBox()
	{
		
		try
		{
			removeChild(renameInput);
		}
		catch(e:Dynamic)
		{
			return;
		}
			
		var renamedFile:File = rightClickedFile.parent.resolvePath( renameInput.value );

		if( rightClickedFile.isDirectory && rightClickedFile.getDirectoryListing().length>0)
			return;
		else if( getLocalURL(rightClickedFile) ==  getLocalURL(renamedFile)  )
			return;
		else if (renamedFile.exists)
			Debug.Log("A file with the new name already exists");
		else
		{
			Assets.MoveAsset( getLocalURL(rightClickedFile), getLocalURL(renamedFile) );
			rightClickedFile.moveTo(renamedFile);
			AssetsPanel.getInstance().populate();
		}
	}
	private inline function getLocalURL(file:File):String
	{
		return StringTools.urlDecode(file.url.substring(Assets.sourceDirectory.url.length+1));
	}
	public function new() 
	{
		super("File Browser", Space.SPACE_WIDTH);
		
		fileItems = new Array<FileItem>();
		fileItemPool = new Array<FileItem>();
		
		currentDirectory =  Assets.sourceDirectory;
	}
	
	public function clearItems() 
	{
		
		for (item in fileItems)
		{
			removeChild( item );
		}
	
		fileItems = [];
	}
	private function getItemFromPool(fileName:String, extension:String, localURL:String,  onClick:FileItem->Void)
	{
		var item:FileItem;
			
		if( fileItemPool[fileItems.length] == null)
		{
			item = new FileItem(fileName, extension, localURL, onItemClick); 
			fileItemPool.push(item);
		}
		
		item = fileItemPool[fileItems.length];
		item.init(fileName, extension, localURL);
		fileItems.push(item);
		return item;
			
	}

	public function populate()
	{
		clearItems();
		removeRenameBox();
		
		var files:Array<File> = currentDirectory.getDirectoryListing();
		var fileItem:FileItem;
		var row:Int = 0;
		var colomn:Int = 0;
		
		
		if (currentDirectory.nativePath !=  Assets.sourceDirectory.nativePath)
		{
			fileItem = getItemFromPool("...", "back", "null", onItemClick);
			
			fileItem.x = colomn * colomnWidth + padding/2;
			fileItem.y = row * padding + 1;
			
			addChild( fileItem );
			row = 1;
		}
		
		
		for(file in files)
		{
			
			fileItem = getItemFromPool(file.name, file.extension, getLocalURL(file), onItemClick);
			addChild( fileItem );
			fileItem.x = colomn * colomnWidth + padding/2;
			fileItem.y = row * padding + 2;
		
			row++;
			if(row>rows-1)
			{
				colomn ++;
				row = 0;
			}
		}
	}

	private function onItemClick(fileItem:FileItem)
	{
		
		
		if ( fileItem.type == FileType.FOLDER )
			currentDirectory = currentDirectory.resolvePath(fileItem.fileName);	
		else if ( fileItem.type == FileType.BACK )
			currentDirectory = currentDirectory.parent;
		else
		{
			var file:File = currentDirectory.resolvePath(fileItem.fileName);
			
			try
			{
				file.openWithDefaultApplication();
			}
			catch(e:IllegalOperationError)
			{
				
				trace(e);
			}
				
		}
		
		populate();

	}


	override public function resize()
	{
		y = 0;
		
		drawGraphics();
		for (element in elements)
		{
			element.resize();
		}
	}

	override public function drawGraphics()
	{
		if(parent == null)return;
		
		
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0x4c4c4c);
		var prevRows:Int = rows;
		
		rows = 0;
		var gridY:Float = 2;
		_height = cast(parent, Space)._height - 26;

		
		while(gridY < _height)
		{
			g.drawRect(2, gridY, _width-4, padding);
			gridY += padding * 2;
			rows += 2;
		}
		rows -=1;
		g.endFill();
		
		var gridX:Float = colomnWidth;
		colomns = 0;
		while(gridX < _width)
		{
			g.lineStyle(1, 0x2e2e2e);
			g.moveTo(gridX, 2);
			g.lineTo(gridX, _height - 1);
			g.lineStyle(1, 0x6a6a6a);
			g.moveTo(gridX+1, 2);
			g.lineTo(gridX+1, _height - 1);
			gridX += colomnWidth;
			colomns ++;
		}

		
		
		if (rows != prevRows && rows >=1)
		{
			populate();
		}

	}

}