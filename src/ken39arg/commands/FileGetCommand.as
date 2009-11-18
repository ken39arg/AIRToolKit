package ken39arg.commands
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import ken39arg.commands.CommandBase;
	import ken39arg.commands.LoaderCommand;
	
	public class FileGetCommand extends CommandBase
	{
		private var _fileName:String;
		
		private var _loader:Loader;
		
		public function set loader(v:Loader):void
		{
			_loader = v;	
		}
		
		public function get loader():Loader
		{
			return _loader;
		}
		
		public function FileGetCommand(fileName:String, targetLoader:Loader)
		{
			_fileName = fileName;
			loader = targetLoader;
		}
		
		override public function execute():void
		{
			trace("{FileGetCommand}:"+_fileName);
			
			if (_fileName.indexOf("http") > -1) {
				trace("load http");
				// http
				var command:LoaderCommand = new LoaderCommand({
					'loader': loader,
					'url': _fileName
				});
				command.addEventListener(Event.COMPLETE, httpLoaderCompleteHandler);
				command.addEventListener(ErrorEvent.ERROR, httpLoaderErrorHandler);
				
				command.execute();
				
			} else {
				trace("load local");
				// local
				try {
					var file:File = new File(_fileName);
					var fileStream:FileStream = new FileStream();
					var biteArray:ByteArray = new ByteArray();
					fileStream.open(file, FileMode.READ);
					fileStream.readBytes(biteArray);
					fileStream.close();
					
					trace("load length: "+biteArray.length);
					
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, localLoaderCompleteHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, localLoaderErrorHandler);
					
					var loaderContext:LoaderContext = new LoaderContext(); 
					loaderContext.allowLoadBytesCodeExecution = true; 
					
					loader.loadBytes(biteArray, loaderContext);
					
				} catch (e:Error) {
					dispatchError("Local file load Error: "+e.toString());
				}
			}
		}
		
		private function httpLoaderCompleteHandler(event:Event):void
		{
			trace("http load complete");
			event.target.removeEventListener(Event.COMPLETE, httpLoaderCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, httpLoaderErrorHandler);
			dispatchComplete();
		}

		private function httpLoaderErrorHandler(event:ErrorEvent):void
		{
			trace("http load error");
			event.target.removeEventListener(Event.COMPLETE, httpLoaderCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, httpLoaderErrorHandler);
			dispatchError(event.toString());
		}

		private function localLoaderCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, localLoaderCompleteHandler);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, localLoaderErrorHandler);
			dispatchComplete();
		}
		
		private function localLoaderErrorHandler(event:ErrorEvent):void
		{
			event.target.removeEventListener(Event.COMPLETE, localLoaderCompleteHandler);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, localLoaderErrorHandler);
			dispatchError(event.toString());
		}
	}
}
