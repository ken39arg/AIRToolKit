package ken39arg.commands
{
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	/**
	 * 変数内にCommandインスタンスを残して参照地獄にならないように、
	 * 実行中のICommandを実装したクラスを一時的にホールドする為のクラスです。
	 * 実行終了後にICommandインスタンスへの参照は開放されます。
	 * 
	 * @example
	 * <listing version="3.0">
	 * var serialCommand = new SerialCommand([
	 *   new Command(null, trace, ["test"]);
	 *   new WaitCommand(1000);
	 *   new Command(null, trace, ["test"]);
	 * ])
	 * 
	 * CommandContainer.execute( serialCommand );
	 * </listing>
	 */
	public class CommandContainer
	{
		protected static var commandDict:Dictionary
		protected static var _numCommands:int = 0;
		
		public static function execute(command:ICommand):ICommand
		{
			if(commandDict==null)
				commandDict = new Dictionary();
				
			if(commandDict[command]){
				throw new Error("CommandContainer.execute() this command is alrealdy registerd");
			}else{
				commandDict[command] = command;
				_numCommands++;
				
				//trace("CommandComtainer.added",_numCommands);
			}
			
			command.addEventListener(Event.COMPLETE, executeHandler);
			command.execute();
			
			return command;
		}
		
		public function get numCommands():int
		{
			return _numCommands;
		}
		
		protected static function executeHandler(e:Event):void
		{
			var command:ICommand = ICommand(e.target);
			command.removeEventListener(Event.COMPLETE, executeHandler);
			_numCommands--;
			
			//trace("CommandComtainer.complete",_numCommands);
			
			//すぐ消さない。１フレームぐらい待ったほうがいい？？
			commandDict[command] = null;
			delete commandDict[command];
		}
	}
}