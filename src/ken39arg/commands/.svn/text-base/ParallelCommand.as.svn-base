package ken39arg.commands
{
	import flash.events.Event;
	
	/**
	 * Executes series of commands at once, and wait for all complement.
	 * After execution, this dispatches Event.COMPLETE.
	 * Used for multiple data loading.
	 * 
	 * var coms : Array = [
	 * 		new Command("hello"),
	 * 		new WaitCommand(1000),
	 * 		new Command("world")];
	 * 
	 * var pCom : ParallelCommand = new ParallelCommand( coms );
	 * pCom.addEventListener(Event.COMPLETE, _commandCompleteHandler);
	 * pCom.execute();
	 * 
	 */
	public class ParallelCommand extends BatchCommand
	{
		public function ParallelCommand( commandArray:Array = null )
		{
			super( commandArray );
		}
		
		
		
		
		
		override public function execute():void
		{
			for(var i:int = 0; i<_commands.length; i++)
			{
				var c : ICommand = _commands[ i ];
				c.addEventListener(Event.COMPLETE, doNextCompleteHandler);
				c.execute();
			}
		}
		

		protected function doNextCompleteHandler( e:Event ):void
		{
			var c : ICommand = ICommand(e.target);
			c.removeEventListener(Event.COMPLETE, doNextCompleteHandler);
			_index ++;
			
			if(_index == _commands.length )
				dispatchComplete();	
		}
	}
}