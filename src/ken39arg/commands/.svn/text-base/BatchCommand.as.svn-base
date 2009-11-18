package ken39arg.commands
{
	import flash.events.EventDispatcher;
	
	/**
	 * ParallelCommand と SerialCommand のベースとなる抽象クラスです。
	 * このクラスが実際にインスタンス化されることはありません。
	 */
	public class BatchCommand extends CommandBase
	{
		protected var _commands:Array
		protected var _index:Number
		
		public function BatchCommand( commandArray:Array=null )
		{
			super();
			
			_index = 0;
			_commands = (commandArray==null || commandArray.length == 0)? [new NullCommand()] : commandArray.concat();
		}
		
		
		/**
		 * ICommandインターフェースを実装したコマンドを処理に追加します。
		 * @param com Command
		 */
		public function push(com:ICommand):void
		{
			_commands.push(com);
		}
		
		
		/**
		 * Commandインスタンスを作成し処理に追加するショートカット関数です。
		 */
		public function pushCommand(thisObject:*, func:Function, params:Array=null):void
		{
			var c:Command = new Command(thisObject, func, params);
			push(c);
		}
		
		
		/**
		 * WaitCommandインスタンスを作成し処理に追加するショートカット関数です。
		 */
		public function pushWait( delay:Number ):void
		{
			var c:WaitCommand = new WaitCommand(delay);
			push(c);
		}
		
		
		/**
		 * SerialCommandインスタンスを作成し処理に追加するショートカット関数です。
		 */
		public function pushSerial( commands:Array = null ):void
		{
			var c:SerialCommand = new SerialCommand(commands);
			push(c);
		}
		
		
		/**
		 * ParallelCommandインスタンスを作成し処理に追加するショートカット関数です。
		 */
		public function pushParallel( commands:Array = null ):void
		{
			var c:ParallelCommand = new ParallelCommand(commands);
			push(c);
		}
		
		public function pushAsync(thisObject:Object, func:Function, params:Array, eventDispatcher:EventDispatcher, eventType:String):void
		{
			var c:AsyncCommand = new AsyncCommand(thisObject, func, params, eventDispatcher, eventType);
			push(c);
		}
		
		public function pushFrameWait(frameNum:int):void
		{
			var c:FrameWaitCommand = new FrameWaitCommand(frameNum);
			push(c);
		}
	}
}