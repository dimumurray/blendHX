package blendhx.editor.panels;
import openfl.text.TextFieldAutoSize;
import blendhx.editor.uicomponents.TextInput;
import blendhx.core.assets.Assets;

import openfl.errors.IllegalOperationError;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import blendhx.core.components.Entity;
import blendhx.editor.uicomponents.Button;
import blendhx.editor.assets.FileType;


import blendhx.core.*;
import blendhx.editor.spaces.*;
import blendhx.editor.panels.*;
import blendhx.core.components.*;
import openfl.events.Event;
import openfl.display.Graphics;
import openfl.filesystem.File;

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
		//dont rename if it's a folder and contians files
		if( rightClickedFile.isDirectory && rightClickedFile.getDirectoryListing().length>0)
			return;
		//don't rename if it want's in fact renamed at all
		else if( getLocalURL(rightClickedFile) ==  getLocalURL(renamedFile)  )
			return;
		//don't rename if a file with the same name already exists on the hard drive
		else if (renamedFile.exists)
			trace("A file with the new name already exists");
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
		if(Assets.projectDirectory == null)
			return;
		
		if(currentDirectory == null)
			currentDirectory = Assets.sourceDirectory;
		
		
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
