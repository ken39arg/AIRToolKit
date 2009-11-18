package ken39arg.commands
{
	import flash.events.Event;
	
	/**
	 * 内包したコマンドをX回繰り返すコマンド。
	 * X=0の場合、無限に実行し続ける。
	 * 
	 * 点滅とかピングとか定期的な処理を行いたい場合に。
	 * 
	 * @usage
	 * 
	 * var lc:LoopCommand = new LoopCommand( new Command(null, "hello world"), 3);
	 * lc.execute();
	 * 
	 */
	public class LoopCommand extends CommandBase
	{
		protected var _loopCnt:Number;
		protected var _command:CommandBase;
		protected var _repeatNum:Number;
		
		protected var _canceled : Boolean
		
		public function LoopCommand(command:CommandBase, repeatNum:Number=1)
		{
			super();
			_command = command;
			_repeatNum = repeatNum;
			_loopCnt = 0;
		}
		
		override public function execute():void
		{
			doNext();
		}
		
		//キャンセルの実装は暫定的。挙動をもっとよく考えること！！
		override public function cancel():void
		{
			_canceled = true;
		}
		
		protected function doNext():void
		{
			if(_canceled==true) return;
			
			_command.addEventListener(Event.COMPLETE, doNextCompleteHandler);
			_command.execute();
		}
		
		protected function doNextCompleteHandler( e:Event ):void
		{
			_command.removeEventListener(Event.COMPLETE, doNextCompleteHandler);
			_loopCnt++;
			
			if(_loopCnt >= _repeatNum || _repeatNum<0){
				dispatchComplete();
			}else{
				doNext();
			}
		}
	}
}