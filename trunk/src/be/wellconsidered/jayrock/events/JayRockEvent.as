package be.wellconsidered.jayrock.events
{
	import flash.events.Event;

	public class JayRockEvent extends Event
	{
		public static var COMPLETE:String = "Complete";
		public static var ERROR:String = "Error";
		
		private var _data:*;
		
		public function JayRockEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}