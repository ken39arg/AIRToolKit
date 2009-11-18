package ken39arg.commands
{
	
	/**
	 * commandsライブラリで使用される共通インターフェース。
	 */
	public interface ICommand
	{
		function addEventListener(
									type:String, 
									listener:Function, 
									useCapture:Boolean = false, 
									priority:int = 0, 
									useWeakReference:Boolean = false
									):void
										
		
		function removeEventListener(
										type:String, 
										listener:Function, 
										useCapture:Boolean = false
										):void
		
		/**
		 * @eventType Event.COMPLETE 同期、非同期に関わらずexecuteによって行われる処理の終了時にEvent.Completeイベントを発行してください。
		 */
		function execute():void
		
		/**
		 * コマンドの実行を停止する場合のコマンド
		 */
		function cancel():void
	}
}