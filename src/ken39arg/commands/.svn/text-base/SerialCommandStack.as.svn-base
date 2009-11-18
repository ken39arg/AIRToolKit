package ken39arg.commands
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ken39arg.event.SerialCommandEvent;
	
	/**
	 *  全てのコマンドの実行が終了し予約済みのコマンドが空になったことを通知します
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 *  新しいコマンドの実行を通知します
	 *
	 *  @eventType ken39arg.event.SerialCommandEvent.EXECUTE
	 */
	[Event(name="execute", type="ken39arg.event.SerialCommandEvent")]

	/**
	 *  予約済みのコマンドがキャンセルされたことを通知します
	 *
	 *  @eventType ken39arg.event.SerialCommandEvent.CANCEL
	 */
	[Event(name="cancel", type="ken39arg.event.SerialCommandEvent")]

	/**
	 *  実行中のコマンドが終了したことを通知します
	 *
	 *  @eventType ken39arg.event.SerialCommandEvent.FINISH
	 */
	[Event(name="finish", type="ken39arg.event.SerialCommandEvent")]

	/**
	 * 同時に大量のコマンドを実行するのを防ぐため、このクラスを使用して、
	 * 常に１つのコマンドだけが実行されている状態を保ちます. 
	 * 
	 * putでコマンドを登録していくと、順次登録された順にコマンドをシリアルに実行していきます。. 
	 * SerialCommandStackを使用することで現在他のコマンドが動いているかを気にせず、
	 * 一つずつ実行していくことが出来るので便利だと思います。
	 * 特にダウンロードなどの処理は非常に重い処理なのでこのクラスを使用することを推奨します。
	 * 
	 * SerialCommandStack.instanceでシングルトンで利用することもできますが、
	 * 同時に複数の線で実行したいこともあるので、new SerialCommandStack()でも新しいインスタンスを作成できます
	 * 
 	 * @access    public
	 * @package   ken39arg.commands
	 * @author    K.Araga
	 * @varsion   $id : SerialCommandStack.as, v 1.0 2008/02/15 K.Araga Exp $
	 */
	public class SerialCommandStack extends EventDispatcher
	{
		private static var _instance:SerialCommandStack;
		
		private var repos:Array;
		
		private var execCmdName:String = "";
		
		[Bindable]
		/**
		 * コマンド実行中かどうか 
		 */
		public var nowLording:Boolean = false;
		
		/**
		 * コンストラクタ 
		 * @private
		 */
		public function SerialCommandStack()
		{
			repos = [];
		}
		
		/**
		 * インスタンスを取得します 
		 * @return 
		 * 
		 */
		public static function get instance():SerialCommandStack
		{
			if (_instance == null) {
				_instance = new SerialCommandStack();
			}
			return _instance;
		}
		
		/**
		 * インスタンスを削除します. 
		 * 
		 * new でインスタンスを生成した場合は注意してください
		 * 
		 */
		public function close():void
		{
			if (repos != null) {
				while (hasNext()) {
					var cm:Object = getNext();
					var command:ICommand = cm.command as ICommand;
					command.cancel();
					dispatchEvent( new SerialCommandEvent("cancel", false, false, cm.name, execCmdName ));
					execCmdName = cm.name;

				}
			}
			repos = null;
			_instance = null;
		}
		
		/**
		 * コマンドを追加します. 
		 * 
		 * 他のコマンドが実行中でなければexecuteします
		 * 
		 * @param dlCommand
		 * @param name
		 */
		public function put(command:ICommand, name:String = ""):void
		{
			repos.push({command:command, name:name});
			execute();
		}
		
		/**
		 * コマンドをスタックの先頭に追加します.
		 * 
		 * 他のコマンドが実行中でなければ実行します。 
		 * @param command
		 * @param name
		 */
		public function unshift(command:ICommand, name:String = ""):void
		{
			repos.unshift({command:command, name:name});
			execute();
		}
		
		private function hasNext():Boolean
		{
			return (repos.length > 0);
		}
		
		private function getNext():Object
		{
			//var command:ICommand = repos.shift() as ICommand;
			return repos.shift();
		}
		
		private function execute():void
		{
			if (nowLording) {
				return;
			}
			if (hasNext()) {
				// 実行中で無ければ新しいコマンドを実行する
				var cm:Object = getNext();
				var command:ICommand = cm.command as ICommand;
				command.addEventListener(Event.COMPLETE, onCompleteHandler);
				command.execute();
				nowLording = true;
				dispatchEvent( new SerialCommandEvent("execute", false, false, cm.name, execCmdName ));
				execCmdName = cm.name;
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(event.type, arguments.callee);
			nowLording = false;
			dispatchEvent( new SerialCommandEvent("finish", false, false, execCmdName, execCmdName ));
			execute();
		}

	}
}