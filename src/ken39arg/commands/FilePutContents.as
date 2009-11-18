package ken39arg.commands
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import ken39arg.commands.CommandBase;
	
	public class FilePutContents extends CommandBase
	{
		private var contents:ByteArray;
		
		private var fileStream:FileStream;
		
		private var outputFile:File;
		
		public function FilePutContents(contents:ByteArray, file:File)
		{
			this.contents = contents;
			this.outputFile = file;
		}
		
		override public function execute():void
		{
			fileStream = new FileStream();
			fileStream.addEventListener(Event.CLOSE, fileStreamCloseHandler);
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, fileStreamIoErrorHandler);
			fileStream.openAsync(outputFile, FileMode.WRITE);
			fileStream.writeBytes(this.contents, 0, this.contents.length);
			fileStream.close();
		}

		protected function fileStreamCloseHandler(event:Event):void
		{
			fileStream.removeEventListener(Event.CLOSE, fileStreamCloseHandler);
			fileStream.removeEventListener(IOErrorEvent.IO_ERROR, fileStreamIoErrorHandler);
			
			outputFile = null;
			contents = null;
			fileStream = null;
			
			this.dispatchComplete();	
		}
		
		protected function fileStreamIoErrorHandler(event:IOErrorEvent):void
		{
			fileStream.removeEventListener(Event.CLOSE, fileStreamCloseHandler);
			fileStream.removeEventListener(IOErrorEvent.IO_ERROR, fileStreamIoErrorHandler);
			outputFile = null;
			contents = null;
			fileStream = null;
			
			this.dispatchComplete();	
		}
	}
}
