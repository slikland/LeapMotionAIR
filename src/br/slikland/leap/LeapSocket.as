package br.slikland.leap
{
	import br.slikland.leap.events.LeapEvent;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * @author keita
	 */
	
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="socketData", type="flash.events.ProgressEvent")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="leapData", type="br.slikland.leap.events.LeapEvent")]
	public class LeapSocket extends EventDispatcher
	{
		private var _socket:Socket;
		private var _headerReceived:Boolean = false;
		private var _receivedData:ByteArray = new ByteArray();
		
		public function LeapSocket()
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, socketConnect);
			_socket.addEventListener(Event.CLOSE, close);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, error);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
		}
		
		public function connect(ip:String = "127.0.0.1", port:int = 6437):void
		{
			_socket.connect(ip, port);
		}

		private function error(event:ErrorEvent):void
		{
			dispatchEvent(event.clone());
		}

		private function close(event:Event):void
		{
			dispatchEvent(event.clone());
		}

		private function socketData(event:ProgressEvent):void
		{
			if(!_headerReceived)
			{
				_socket.readUTFBytes(_socket.bytesAvailable);
				_headerReceived = true;
				return;
			}
			_socket.readBytes(_receivedData, _receivedData.length);
			while(_receivedData.length > 2)
			{
				// Handling WebSocket Frames.
				// It's ignoring the frame info and masking key.
				// LeapMotion is not sending masked frames, only the size of the frame.
				// FIXTO: Fix it in the future to accept masked frames and other frame properties.
				
				_receivedData.position = 1;
				var payload:int = _receivedData.readByte();
				var len:uint = payload & 0x7F;
				if(payload == 0x7E)
				{
					len = _receivedData.readUnsignedShort();
				}else if(payload == 0x7F)
				{
					len = _receivedData.readUnsignedShort();
				}
				if(_receivedData.length < _receivedData.position + len)
				{
					break;
				}
				var data:String = _receivedData.readUTFBytes(len);
				var json:Object = JSON.parse(data);
				var ba:ByteArray = new ByteArray();
				ba.writeBytes(_receivedData, _receivedData.position);
				_receivedData = ba;
				dispatchEvent(new LeapEvent(LeapEvent.DATA, json));
			}
		}

		private function socketConnect(event:Event):void
		{
			// Not the proper way of sending the websocket headers, but it's working.
			// FIXTO: Fix it in the future to do it properly calculating the WebSocket-key and using more recent WebSocket protocols.
			_socket.writeUTFBytes("GET / HTTP/1.1\r\nHost: 127.0.0.1\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==\r\nSec-WebSocket-Protocol: test\r\nSec-WebSocket-Version: 13\r\nOrigin: 127.0.0.1\r\n\r\n");
			dispatchEvent(event.clone());
		}
	}
}
