package ken39arg.commands
{
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import ken39arg.logging.Logger;
	
	/**
	 * リモートメソッドを実行するためのコマンド
	 * 
	 * @access    public
	 * @author    K.Araga
	 * @varsion   $id : RemotingCommand.as, v 1.0 2008/03/11 K.Araga Exp $
	 */
	public class RemotingCommand extends CommandBase
	{
		protected var _gatewayUrl : String;
		
		protected var _methodName : String;
		
		protected var _responder : Responder;
		
		protected var _argments : Array;
		
		protected var _result : Array;
		
		protected var _con : NetConnection;
		
		/**
		 * コンストラクタ
		 * @param gatewayUrl リモートURL
		 * @param methodName メソッド名
		 * @param responder  Responderオブジェクト(nullの場合、デフォルトで用意しているレスポンダーを使用します)
		 * @param argments   引数
		 * 
		 */
		public function RemotingCommand(gatewayUrl:String, methodName:String, responder:Responder = null, ... argments)
		{
			_result = [];
			
			_gatewayUrl  = gatewayUrl;
			
			if (argments != null && argments.length == 1 && argments[0] is Array) {
				_argments = argments[0] as Array
			} else {
				_argments    = argments;
			}
			_methodName  = methodName;
			
			if (responder == null) {
				responder = new Responder(onResult, onFault);
			}
			_responder = responder;
			super();
		}
		
		/**
		 *　実行します 
		 * 
		 */
		override public function execute():void
		{
			_con = getConnection();
			
			Logger.debug("execute remote : "+_methodName);
			
			if ( _argments.length > 0 ) {
				var param:Array = _argments.concat();
				param.unshift( _methodName, _responder );
				_con.call.apply(_con, param);
			} else {
				_con.call(_methodName, _responder);
			}
		}
		
		/**
		 * 結果を取得します
		 * 先入れ先出し
		 * @return 
		 * 
		 */
		public function getResult():Object
		{
			return _result.shift();
		}
		
		/**
		 * NetConnectionオブジェクトを取得します 
		 * @return 
		 * 
		 */
		protected function getConnection() : NetConnection
		{
			var con:NetConnection = new NetConnection();
			con.connect(_gatewayUrl);
			con.objectEncoding = ObjectEncoding.AMF3;
			con.addEventListener(SecurityErrorEvent.SECURITY_ERROR, conSecurityErrorHandler);
			con.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			return con;
		}
		
		private function conSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			event.target.removeEventListener(event.type, conSecurityErrorHandler);
			_con.close();
			_con = null;
			Logger.error("conSecurityErrorHandler:"+event);
		}
		
		private function onNetStatusHandler(event:NetStatusEvent):void
		{
			Logger.debug("NetStatus:info=" + event.info + " :type=" + event.type)
		}
		
		/**
		 * デフォルトの結果取得ハンドラ
		 * オーバーライドしてカスタマイズするか、コンストラクタでresponderを指定してください
		 */
		protected function onResult(ret:*):void
		{
			_con.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, conSecurityErrorHandler);
			_con.close();
			_con = null;
			
			_result.push(ret);
			_responder = null;
			_argments = null;
			dispatchComplete();
		}
		
		/**
		 * デフォルトのエラーハンドラ
		 * @param ret
		 * 
		 */		
		protected function onFault(ret:*):void
		{
			//Logger.debug("RemotingCommand::onFault");
			//Logger.putVerdump(ret);
			_con.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, conSecurityErrorHandler);
			_con.close();

			//trace(ret);

			Logger.stactrace(ret);
			_con = null;
			_responder = null;
			_argments = null;
			dispatchError("remote call error. gateway is " + this._gatewayUrl + "  method is " + this._methodName);
			dispatchComplete();
		}
	}
}