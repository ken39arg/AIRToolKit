package ken39arg.commands
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	/**
	 *  コマンドの実行が完了したことを通知する
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 *  コマンドの実行が失敗したことを通知する
	 *
	 *  @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]

	/**
	 * commandsパッケージで使用されるコマンドのルートとなる抽象クラス。
	 * 独自のコマンドクラスを作成する場合には、基本的にこのクラスを継承してください。
	 * 
	 * update K.Araga
	 * Errorイベントも定義しました
	 * Error時はcancelを呼び出すつもりです
	 */
	public class CommandBase extends EventDispatcher implements ICommand
	{
		/**
		 * テンプレート関数。
		 * 
		 * この関数をオーバーライドして実行したい処理を書きます。
		 * 同期処理、非同期処理にかかわらず、処理の終了時には関数dispatchComplete()をコールしてください。
		 */
		public function execute():void{}
		
		
		/**
		 * テンプレート関数。
		 * 
		 * この関数は将来の拡張の為に予約されています。
		 */
		public function cancel():void{}
		
		
		/**
		 * コマンドの終了を通知する為に、Event.COMPLETEを発行します。
		 */
		protected function dispatchComplete():void
		{
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * コマンドの失敗を通知するためにErrorEvent.ERRORを発行します
		 */
		protected function dispatchError(message:String = ""):void
		{
			dispatchEvent( new ErrorEvent(ErrorEvent.ERROR, false, false, message) );
		}
	}
}