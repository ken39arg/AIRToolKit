package ken39arg.commands
{
	public class Command extends CommandBase
	{
		protected var _thisObject : Object
		protected var _function : Function;
		protected var _params : Array;
		
		public function Command(thisObject:Object, func:Function, params:Array=null)
		{
			super();
			_thisObject = thisObject
			_function = func
			_params = params
		}

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
