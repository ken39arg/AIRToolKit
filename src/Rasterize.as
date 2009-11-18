package
{
	import airtoolkit.FileHandlingApplication;

	import ken39arg.commands.FilePutContents;
	import ken39arg.util.SnapShot;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class Rasterize extends FileHandlingApplication
	{
		private var _timer : Timer;
		private var _repeat_count : int = 0;
		private var _waiting_count : int = 0;		
		
		public function get outPutFile():File
		{
			if ( repeat <= 1 ) {
				return new File(outPutFileName);
			}
			return new File(outPutFileName + "-" + String(_repeat_count));
		}
		
		public function get outPutFileName():String
		{
			return String(args[1]);
		}
				
		public function get delay():int
		{
			if (args.length < 3) {
				return 100;
			} else {
				return int(args[2]) * 100;
			}
		}

		public function get repeat():int
		{
			if (args.length < 4) {
				return 1;
			} else {
				return (int(args[3]) > 0) ? int(args[3]) : 1;
			}
		}
		
		override protected function usage() : void
		{
			super.usage();
			trace("  arguments 2: output file name");
			trace("  arguments 3: delay rasterize interval (default: 1 sec)");
			trace("  arguments 4: repeat rasterize count   (default: 1 time)");
		}
		
		override protected function actionToLoader() : void
		{
			addChild(loader);
			
			_waiting_count = repeat;
			_timer = new Timer(delay, repeat);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			_timer.start();			
		}
		
		override protected function varidateArgs() : Boolean
		{
			if( args.length < 2 ) {
				trace('option がすくないです');
				usage();
				error('--');
				return false;
			}
			return true;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var imageByte:ByteArray = SnapShot.takeSnapshotAsPNG(loader);
			var command:FilePutContents = new FilePutContents(imageByte, outPutFile);
			command.addEventListener(Event.COMPLETE, snapshotCompleteHandler);
			command.addEventListener(ErrorEvent.ERROR, snapshotErrorHandler);
			command.execute();
			_repeat_count++;
		}

		private function timerCompleteHandler(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			if (_waiting_count == 0) {
				exit();
			}
			_timer = new Timer(50, 1);
			_timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
			{
				// 遅延終了
				exit();
			});
			_timer.start();
		}
		
		private function snapshotCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, snapshotCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, snapshotErrorHandler);
			
			_waiting_count--;
			if (_waiting_count == 0) {
				exit();
			}
		}
		
		private function snapshotErrorHandler(event:ErrorEvent):void
		{
			event.target.removeEventListener(Event.COMPLETE, snapshotCompleteHandler);
			event.target.removeEventListener(ErrorEvent.ERROR, snapshotErrorHandler);
			_timer.stop();
			error(event.toString());
		}
	}
}
