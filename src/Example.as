package 
{
	import br.slikland.leap.LeapSocket;
	import br.slikland.leap.events.LeapEvent;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	public class Example extends Sprite
	{
		
		private var _socket:LeapSocket;
		
		public function Example()
		{
			_socket = new LeapSocket();
			_socket.addEventListener(Event.CONNECT, socketConnect);
			_socket.addEventListener(Event.CLOSE, close);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, error);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
			_socket.addEventListener(LeapEvent.DATA, leapData);
			
			_socket.connect("127.0.0.1", 6437);
		}

		private function error(event:ErrorEvent):void
		{
			trace("Error:", event.text);
		}

		private function close(event:Event):void
		{
			trace("Close");
		}

		private function leapData(event:LeapEvent):void
		{
			trace(event.data);
			for(var p:String in event.data)
			{
				trace(p);
			}
		}

		private function socketConnect(event:Event):void
		{
			trace("Init!");
		}
	}
}
