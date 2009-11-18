package ken39arg.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;

	public class SnapShot extends EventDispatcher
	{
		public function SnapShot()
		{
			super();
		}
		
		public static function takeSnapshot(target:IBitmapDrawable):BitmapData
		{
			var width:int;
			var height:int;
			
			if (target is DisplayObject) {
				var d:DisplayObject=target as DisplayObject;
				width=d.width;
				height=d.height;
			} else if (target is BitmapData) {
				var b:BitmapData=target as BitmapData;	
				width=b.width;
				height=b.height;
			} else {
				throw new IllegalOperationError("target must be typeof DisplayObject or BitmapData");
			}
			
			var snapshot:BitmapData = new BitmapData(width, height, true);
			snapshot.draw(target);
			
			return snapshot;
		}
		
		public static function takeSnapshotAsJPEG(target:IBitmapDrawable, quality:Number=80.0):ByteArray
		{
			var bitmap:BitmapData = takeSnapshot(target);
			var encorder:JPEGEncoder = new JPEGEncoder(quality);
			var ba:ByteArray = encorder.encode(bitmap);
			return ba;
		}
		
		public static function takeSnapshotAsPNG(target:IBitmapDrawable):ByteArray
		{
			var bitmap:BitmapData = takeSnapshot(target);
			var encorder:PNGEncoder = new PNGEncoder();
			var ba:ByteArray = encorder.encode(bitmap);
			return ba;
		}
	}
}
