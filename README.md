LeapMotionAIR
=============

LeapMotion code to be used wir Adobe AIR AS3 3.0 or greater.

It uses the HTTP WebSocket protocol for HTML5 to communicate.
It means, doesn't need to add any native extension, just add the code to your library and you can connect to LeapMotion socket.

	public function Main()
	{
		var leapSocket:LeapSocket = new LeapSocket();
		leapSocket.addEventListener(Event.CONNECT, socketConnect);
		leapSocket.addEventListener(Event.CLOSE, close);
		leapSocket.addEventListener(IOErrorEvent.IO_ERROR, error);
		leapSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
		leapSocket.addEventListener(LeapEvent.DATA, leapData);
		
		leapSocket.connect("127.0.0.1", 6437);
	}

	private function leapData(event:LeapEvent):void
	{
		// Returns a Frame Object
		// Frame object: https://developer.leapmotion.com/documentation/api/class_leap_1_1_frame
		// LeapMotion Javascript tutorial: https://developer.leapmotion.com/documentation/guide/Sample_JavaScript_Tutorial
		trace(event.data);
	}

	private function error(event:ErrorEvent):void
	{
		trace("Error:", event.text);
	}

	private function close(event:Event):void
	{
		trace("Close");
	}

	private function connect(event:Event):void
	{
		trace("Connect")
	}

