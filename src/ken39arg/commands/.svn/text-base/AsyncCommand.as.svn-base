package ken39arg.commands
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * Executes async function call. E.G. Loader, URLLoader, etc...
	 * This Command register functions event dispacher and catch their event.
	 * After complete command, this dispaches Event.COMPLETE
	 * 
	 * @usage
	 * 
	 * var loader:URLLoader = new URLLoader();
	 * var command:ICommand = new AsyncCommand(loader, loader.load, [new URLRequest(url);], loader.loaderContent, Event.COMPLETE);
	 * command.addEventListener(Event.COMPLETE, _comandCompleteHandler);
	 * command.execute();
	 */
	public class AsyncCommand extends Command
	{
		protected var _eventDispatcher : EventDispatcher;
		protected var _eventType : String;
		
		/**
		 * @param thisObject Scpoe used as This
		 * @param func Function for execute
		 * @param EventDispatcher Object that dispaches functions complete event.
		 * @param Type of Event for EventDispatcher.
		 */
		public function AsyncCommand(thisObject:Object, func:Function, params:Array, eventDispatcher:EventDispatcher, eventType:String)
		{
			super(thisObject, func, params);
			
			_eventDispatcher = (eventDispatcher)? eventDispatcher : thisObject as EventDispatcher;
			_eventType = eventType;
		}
		
		override public function execute():void
		{
			_eventDispatcher.addEventListener(_eventType, executeCompleteHandler);
			_function.apply(_thisObject, _params)
		}
		
		protected function executeCompleteHandler( e:Event ):void
		{
			_eventDispatcher.removeEventListener(_eventType, executeCompleteHandler);
			this.dispatchComplete();
		}
	}
}