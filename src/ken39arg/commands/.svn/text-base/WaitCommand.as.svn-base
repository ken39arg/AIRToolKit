package ken39arg.commands
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Dispatches Event.COMPLETE event after certain delay.
	 * Used for taking a break between multiple commands.
	 * 
	 * @usage
	 * var command : WaitCommand = new WaitCommand(1000);
	 * command.execute();
	 */
	public class WaitCommand extends CommandBase
	{
		protected var _timer:Timer
		protected var _delay:Number
		
		/**
		 * dispatches Event.COMPLETE event after certain delay.
		 * @param millisecond duration for delay
		 */
		public function WaitCommand( delay:Number = 1000)
		{
			super();
			_delay = delay
		}
		
		
		override public function execute():void
		{
			_timer = new Timer(_delay, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler);
			_timer.start();
		}
		
		
		protected function executeCompleteHandler(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler );
			_timer.stop();
			_timer = null;
			dispatchComplete();
		}
	}
}