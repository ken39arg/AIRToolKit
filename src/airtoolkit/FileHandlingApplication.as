package airtoolkit
{
	import ken39arg.commands.FileGetCommand;
	
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	public class FileHandlingApplication extends CLIApplication
	{
		override protected function usage() : void
		{
			super.usage();
			trace("  arguments 1: target file name");
		}
		private var _loader:Loader;
		
		public function get loader():Loader
		{
			return _loader;
		}

		public function set loader(v:Loader):void
		{
			_loader = v;
		}
		
		public function get loadFileName():String
		{
			return String(args[0]);
		}
		
		
		override protected function execute() : void
		{
			if (!varidateArgs()) {
				return;
			}
			
			_loader = new Loader();
			
			// swfのロード
			var command:FileGetCommand = new FileGetCommand(loadFileName, _loader);
			
			command.addEventListener(Event.COMPLETE, fileGetCompleteHandler);
			command.addEventListener(ErrorEvent.ERROR, fileGetErrorHandler);
			
			command.execute();
		}

		protected function varidateArgs() : Boolean
		{
			if( args.length < 1 ) {
				error('option がすくない');
				return false;
			}
			return true;
		}
		
		protected function actionToLoader() : void
		{
			trace("Content-Type: "+ loader.contentLoaderInfo.contentType);
			trace("bytes-total: "+ loader.contentLoaderInfo.bytesTotal);
			trace("toString: "+ loader.contentLoaderInfo.toString());
			exit();
		}		
		
		private function fileGetCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, fileGetCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, fileGetErrorHandler);
			if (event.target is FileGetCommand) {
				_loader = FileGetCommand(event.target).loader;
				actionToLoader();
			} else {
				error("System Error unknown event target");
			}
		}
		
		private function fileGetErrorHandler(event:ErrorEvent):void
		{
			event.target.removeEventListener(Event.COMPLETE, fileGetCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, fileGetErrorHandler);
			error(event.toString());
		}
	}
}
