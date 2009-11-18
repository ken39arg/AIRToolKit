package ken39arg.commands
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import ken39arg.commands.CommandBase;

	public class LoaderCommand extends CommandBase
	{
		protected var paramObj:Object
		protected var loader:Loader
		
		public function LoaderCommand(paramObj:Object)
		{
			this.paramObj = paramObj;
		}
		
		override public function execute():void
		{
			try {
				var req:URLRequest = this.buildURLRequest();
				loader = this.buildLoader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler, false, 0, true);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler, false, 0, true);
				loader.load(req);
			} catch (e:Error) {
				dispatchError(e.toString());
			}
		}
		
		protected function _completeHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
			
			paramObj = null;
			loader = null;
			dispatchComplete();	
		}
		
		protected function _ioErrorHandler(e:Event):void
		{
			if (paramObj.alternativeURL) {
				loader.load(new URLRequest(paramObj.alternativeURL));
			} else {
				dispatchError(e.toString());
			}
		}
		
		protected function buildURLRequest():URLRequest
		{
			var req:URLRequest
			if ( paramObj.url ) {
				req = new URLRequest(paramObj.url);
			} else if ( paramObj.request ) {
				req = paramObj.request;
			} else if ( paramObj.urlScope && paramObj.urlProp ) {
				req = new URLRequest( paramObj.urlScope[paramObj.urlProp] );
			}
			return req;
		}
		
		protected function buildLoader():Loader
		{
			var loader:Loader
			if ( paramObj.loader) {
				loader = paramObj.loader;
			} else if ( paramObj.loaderScope && paramObj.loaderProp ) {
				loader = paramObj.loaderScope[paramObj.loaderProp]
			} else {
				loader = new Loader();
			}
			return loader;
		}
	}
}
