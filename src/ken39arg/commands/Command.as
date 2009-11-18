package ken39arg.commands
{
	/**
	 * 関数execute()をコールすることで、あらかじめ登録しておいた処理を実行します。
	 * 処理の終了後にはEvent.COMPLETEが発行されます。
	 * 
	 * Commandクラスの現状の課題は、インスタンスの作成時の段階で、
	 * 関数およびパラメーターが存在していなければならないことです。
	 * 将来的には関数、パラメーターに対して遅延評価を行うことのできる仕組みを実装する予定です。
	 * 
	 * @example 以下はCommandクラスの基本的な使い方です。
	 * <listing version="3.0">
	 * var command:Command = new Command(null, trace, [""]);
	 * command.execute();
	 * </listing>
	 * 
	 */
	public class Command extends CommandBase
	{
		protected var _thisObject : Object
		protected var _function : Function;
		protected var _params : Array;
		
		/**
		 * 関数execute()実行時に行いたい処理を登録します。
		 * 
		 * @param thisObject Thisとして使用されるスコープです。AS3では指定する必要はありません。AS2との互換性の為に存在しています。
		 * @param func:Function 登録したい関数の参照。
		 * @param params:Array 関数実行時に渡されるパラメーター
		 */
		public function Command(thisObject:Object, func:Function, params:Array=null)
		{
			super();
			_thisObject = thisObject
			_function = func
			_params = params
		}
		
		
		/**
		 * コンストラクタで登録した処理を実行します。
		 * 
		 * @eventType Event.COMPLETE
		 */
		override public function execute():void
		{
			if(_params==null){
				_function.apply(_thisObject);
			}else{
				_function.apply(_thisObject, _params);
			}
			
			this.dispatchComplete();
		}
	}
}