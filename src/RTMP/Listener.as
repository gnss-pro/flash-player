package RTMP
{
    import flash.display.Sprite;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.external.ExternalInterface;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;

    public class Listener extends Sprite
    {
        var netConnect2:NetConnection;
        var receiveStream:NetStream;
        var video:Object;
        var metaListener:Object;
        var videoWidth:int;
        var videoHeight:int;
        var url:String;
        var flvname:String;
		var httpStream:URLStream;
        public var state:int = 1;

        public function Listener(param1:String)
        {
            this.url = param1;
           	this.start();
            trace("Listen " + param1);
            return;
        }// end function
		
		function start():void{
			this.netConnect2 = new NetConnection();
			this.video = new Video();
			this.netConnect2.addEventListener(NetStatusEvent.NET_STATUS, this.netConnectHandler2);
			this.netConnect2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
			this.netConnect2.addEventListener(NetStatusEvent.NET_STATUS, this.nstat);
			this.netConnect2.maxPeerConnections = 100;
			this.netConnect2.connect(null);
			this.receiveStream = new NetStream(this.netConnect2);
			this.receiveStream.bufferTime = 0;
			this.receiveStream.bufferTimeMax = 2;
			this.receiveStream.addEventListener(NetStatusEvent.NET_STATUS, this.nstat);
			this.receiveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
			this.receiveStream.addEventListener(IOErrorEvent.IO_ERROR, this.mistake);
			this.metaListener = new Object();
			this.metaListener.onMetaData = this.onMetaData;
			this.receiveStream.client = this.metaListener;
			this.receiveStream.play(null);
			connServer(this.url);
			this.video.attachNetStream(this.receiveStream);
		}
		
        function onMetaData(param1:Object) : void
        {
            var _loc_2:* = param1.duration;
            return;
        }// end function

        function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            this.state = 1;
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "listenNetError");
            return;
        }// end function

        function netConnectHandler2(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "startListen");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenNetError");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function netmistake(event:AsyncErrorEvent) : void
        {
            this.state = 1;
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "ListenError");
            return;
        }// end function

        function mistake(event:IOErrorEvent) : void
        {
            this.state = 1;
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "ListenError");
            return;
        }// end function

        function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            trace("ListenerAsyncErrorEvent" + event);
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "ListenError");
            return;
        }// end function

        function nstat(event:NetStatusEvent) : void
        {
            trace("Listener " + event.info.code);
            switch(event.info.code)
            {
                case "NetStream.Buffer.Empty":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "loadListen");
//					this.Play();
                    this.state = 1;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "playListen");
                    this.state = 0;
//					trace("receive buffer is full，currBufferlength:"+this.receiveStream.bufferLength+",maxBuffertime:"+this.receiveStream.bufferTimeMax+",buffertime:"+this.receiveStream.bufferTime);
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenFaild");
                    this.Play();
                    this.state = 1;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenStreamNotFound");
                    this.state = 1;
					this.Play();
                }
                case "NetStream.Play.Stop":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenStreamStop");
                    this.state = 1;
                    this.Play();
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenNetError");
					this.state = 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function setListenParam(param1:int)
        {
            this.receiveStream.bufferTime = param1;
            return;
        }// end function

        function initRec()
        {
            var onmd:Function;
            onmd = function (param1:Object) : void
            {
                return;
            }// end function
            ;
            var cc:* = new Object();
            cc.onMetaData = onmd;
            trace(this.flvname);
            this.receiveStream = new NetStream(this.netConnect2);
            this.receiveStream.client = cc;
            this.receiveStream.play(this.flvname);
            this.video.attachNetStream(this.receiveStream);
            return;
        }// end function

        public function Stop():void
        {
            this.receiveStream.close();
            this.netConnect2.close();
            this.netConnect2.removeEventListener(NetStatusEvent.NET_STATUS, this.netConnectHandler2);
            this.netConnect2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.netConnect2.removeEventListener(NetStatusEvent.NET_STATUS, this.nstat);
            this.receiveStream.removeEventListener(NetStatusEvent.NET_STATUS, this.nstat);
            this.receiveStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this.receiveStream.removeEventListener(IOErrorEvent.IO_ERROR, this.mistake);
            this.netConnect2 = null;
            this.receiveStream = null;
            this.video.clear();
            this.video = null;
			this.httpStream.close();
			httpStream.removeEventListener(Event.COMPLETE,onData);
			httpStream.removeEventListener(ProgressEvent.PROGRESS,onData);
			httpStream.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			httpStream = null;
            return;
        }// end function

		public function Play():void
		{
			this.Stop();
			this.start();
			return;
		}// end function
		
		
		public function connServer(url:String):void{  
			this.httpStream = new URLStream();  
			var request = new URLRequest(url);   
			//			request.method = URLRequestMethod.GET;//设置请求的类型 
			
			httpStream.addEventListener(Event.COMPLETE,onData);
			httpStream.addEventListener(ProgressEvent.PROGRESS,onData);
			httpStream.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			try {  
				httpStream.load(request);//开始发送请求   
			} catch (error:Error) {  
				trace(error);  
				httpStream.close();
			} 
		}  
		private function onData(event:*):void{
			var data:ByteArray = new ByteArray();
			httpStream.readBytes(data,0,httpStream.bytesAvailable);
			trace(data.length);
			this.receiveStream.appendBytes(data);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {  
			trace("ioErrorHandler: " + event);  
			ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "listenStreamStop");
			this.state = 1;
			this.Play();
		}

    }
}
