package ken39arg.commands
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 * SerialCommandを拡張し、ErrorEvent.ERRORの受信でcancelを実行する. 
	 * 
	 * <p>
	 * ErrorEvent.ERRORを受信するとexecuteの実行を行わず残りのコマンドのcancelを実行し、
	 * コマンドを終了させ、ErrorEvent.ERRORを送信します. 
	 * Event.COMPLETEも送出されるので注意してください
	 * </p>
	 * 
	 * @access    public
	 * @package   ken39arg.commands
	 * @author    K.Araga
	 * @varsion   $id : CancelableSerialCommand.as, v 1.0 2008/02/15 K.Araga Exp $
	 */
	public class CancelableSerialCommand extends SerialCommand
	{
		private var _isError : Boolean = false;
		
		public function get isError():Boolean
		{
			return _isError;
		}
		
		public function CancelableSerialCommand(commandArray:Array=null)
		{
			super(commandArray);
		}
		
		override public function execute():void
		{
			doNext();
		}
		
		
		//内部的に次のコマンドを実行
		override protected function doNext():void
		{
			var c :ICommand = _commands[ _index ];
			//trace(_commands[ _index ]);
			if (c == null) {
				_commands[ _index ] = new NullCommand();
				c = _commands[ _index ];
			}
			//trace(c);
			c.addEventListener(Event.COMPLETE, doNextCompleteHandler);
			c.addEventListener(ErrorEvent.ERROR, errorHandler);
			c.execute();
		}
		
		
		//子コマンドが終了したときのハンドラ
		override protected function doNextCompleteHandler( e:Event ):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			e.target.removeEventListener(ErrorEvent.ERROR, errorHandler);
			
			_index ++;
			
			if(_index == _commands.length ){
				this.dispatchComplete();
			}else{
				doNext();
			}		
		}
		
		/**
		 * コマンド失敗時のハンドラ、失敗したコマンド以降のコマンドに対してcancelを実行し、
		 * ErrorEvent.ERRORを送信する
		 */
		protected function errorHandler( e:ErrorEvent ):void
		{
			e.target.removeEventListener(Event.COMPLETE, arguments.callee);
			e.target.removeEventListener(ErrorEvent.ERROR, errorHandler);
			for ( var i:int = _index; i<_commands.length; i++ ) {
				var c : ICommand = _commands[ i ];
				c.cancel();
			}
			_isError = true;
			this.dispatchError(e.text);
			this.dispatchComplete();
		}
		
	}
}