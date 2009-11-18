package airtoolkit
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.InvokeEvent;

	/**
	 * 成功時
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *  失敗時
	 *  @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	
	/**
	 * コマンドラインActionScriptアプリケーションの基本
	 * 
	 * @version $Id$ 
	 */
	public class CLIApplication extends Sprite
	{
		protected function usage():void
		{
			trace("Usege:");
			trace("  -help:  show usage");
		}
		
		protected var args:Array;
		
		public function CLIApplication()
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
		}
		
		private function invokeHandler(event:InvokeEvent):void
		{
			event.target.removeEventListener(InvokeEvent.INVOKE, invokeHandler);
			args = event.arguments;
			
			addEventListener(Event.COMPLETE, function (e:Event):void {
				NativeApplication.nativeApplication.exit();
			});
			
			addEventListener(ErrorEvent.ERROR, function (e:ErrorEvent):void {
				trace('ERROR: '+e.toString());
				NativeApplication.nativeApplication.exit(5);
			});
			
			if (args.length > 0 && args[0] == "-help") {
				usage();
				return exit();
			}
			
			try {
				execute();
			} catch(e:Error) {
				error(e.toString());
			}
		}
		
		/**
		 * このメソッドをオーバーライドする
		 * 
		 * 終了時はexit()をする事
		 */
		protected function execute():void
		{
			error('You must to override execute');
		}
		
		protected function exit():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		protected function error(message:String):void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, message));
		}
	}
}
