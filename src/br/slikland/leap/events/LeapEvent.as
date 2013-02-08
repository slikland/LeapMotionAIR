package br.slikland.leap.events
{
	import flash.events.Event;

	/**
	 * @author keita
	 */
	public class LeapEvent extends Event
	{
		
		public static const DATA:String = "leapData";
		
		public var data:Object;
		
		public function LeapEvent(type:String, data:Object = null)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}
