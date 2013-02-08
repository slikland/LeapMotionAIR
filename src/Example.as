/*
Copyright (c) 2013 Slikland / Keita Kuroki

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

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
		
		/**
		 * @author keita@slikland.com
		 */
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
