package ken39arg.commands
{
	import sketchbook.SketchBook;
	import flash.events.Event;
	
	/**
	 * WaitCommandのonEnterFrame版
	 * 指定フレーム数経過したらEvent.COMPLETEを発行する
	 */
	public class FrameWaitCommand extends CommandBase
	{
		protected var maxCount:int
		protected var count:int
		
		public function FrameWaitCommand( count:int )
		{
			this.count = maxCount = count;
		}
		
		override public function execute():void
		{
			SketchBook.stage.addEventListener(Event.ENTER_FRAME, _enterFrameHandler, false, 0, true);
		}
		
		
		protected function _enterFrameHandler(e:Event):void
		{
			if(count<=0){
				SketchBook.stage.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
				this.dispatchComplete();	
			}
			
			count--;
		}
	}
}