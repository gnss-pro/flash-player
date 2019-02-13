package RTMP
{
    import flash.display.Sprite;
    import flash.events.AsyncErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SampleDataEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.StatusEvent;
    import flash.external.ExternalInterface;
    import flash.media.Camera;
    import flash.media.Microphone;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.net.ObjectEncoding;

    public class Publisher extends Sprite
    {
        var _video:Video;
        var _cam:Camera;
        var _mic:Microphone;
        var _nc:NetConnection;
        var _ns:NetStream;
        var videoWidth:int;
        var videoHeight:int;
        var server:String;
        var flvname:String;
        var showVideo:Boolean = false;
        var showAudio:Boolean = true;
        public var state:int = 1;
        var buffer:Number = 1;
        var bufferMax:Object = 1;

        public function Publisher(param1:String, param2:String, param3 = 320, param4 = 240)
        {
            this.server = param1;
            this.flvname = param2;
            this.videoWidth = param3;
            this.videoHeight = param4;
            trace("publish " + param1);
            return;
        }// end function

        public function checkMic() : int
        {
            try
            {
                this._mic = Microphone.getMicrophone();
                this._mic.addEventListener(StatusEvent.STATUS, this.onMicStatus);
                if (this._mic.muted)
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "micDenied");
                    this.Stop();
                    return 2;
                }
                if (this._mic == null)
                {
                    trace("mic faild");
                    this.Stop();
                    return 1;
                }
				
                this._video = new Video();
                this.createChildren();
                this.initConn();
                return 0;
            }
            catch (E)
            {
                return 1;
            }
            return 0;
        }// end function

        function onMicStatus(event:StatusEvent) : void
        {
            if (event.code == "Microphone.Unmuted")
            {
            }
            else if (event.code == "Microphone.Muted")
            {
                RtmpManager.stopTalkback();
                ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "micDenied");
            }
            return;
        }// end function

        public function onBWCheck(param1) : void
        {
            return;
        }// end function

        public function onBWDone(param1) : void
        {
            return;
        }// end function

        function createChildren() : void
        {
            if (this.showVideo)
            {
                this._cam = Camera.getCamera();
                if (this._cam != null)
                {
                    this._cam.setQuality(144000, 85);
                    this._cam.setMode(this.videoWidth, this.videoHeight, 15);
                    this._cam.setKeyFrameInterval(60);
                    this._video.attachCamera(this._cam);
                    addChild(this._video);
                }
            }
            if (this.showAudio)
            {
                if (this._mic != null)
                {
                    this._mic.setSilenceLevel(0, -1);
                    this._mic.gain = 80;
                    this._mic.setLoopBack(false);
                }
                else
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "noMIC");
                    RtmpManager.stopTalkback();
                }
            }
            return;
        }// end function

        function initConn() : void
        {
            this._nc = new NetConnection();
            this._nc.addEventListener(NetStatusEvent.NET_STATUS, this.netConnectHandler2);
            this._nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._nc.objectEncoding = ObjectEncoding.AMF3;
            this._nc.client = this;
            this._nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatus);
            this._nc.connect(this.server,true);
            return;
			
        }// end function

        function publish() : void
        {
            this._ns = new NetStream(this._nc);
            this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._ns.addEventListener(IOErrorEvent.IO_ERROR, this.mistake);
            this._ns.bufferTimeMax = 0.1;
            this._ns.bufferTime = this.buffer;
            this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.netStatus);
            if (this.showVideo)
            {
                this._ns.attachCamera(this._cam);
            }
            if (this.showAudio)
            {
                this._ns.attachAudio(this._mic);
            }
            this._ns.publish(this.flvname, "live");
            return;
        }// end function

        function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            this.state = 1;
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "uploadNetError");
            return;
        }// end function

        function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "uploadError");
            return;
        }// end function

        function mistake(event:IOErrorEvent) : void
        {
            this.state = 1;
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "0", "uploadError");
            return;
        }// end function

        function netConnectHandler2(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadRecive");
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadNetError");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function netStatus(event:NetStatusEvent) : void
        {
            trace("publish " + event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.publish();
					trace("publish:connect success,start pulish");
                    this.state = 0;
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "upload");
                    this.state = 0;
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadfull");
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadFaild");
                    this.Play();
                    this.state = 1;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.Play();
                    this.state = 1;
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadFaild");
                    break;
                }
                case "NetConnection.Connect.Closed":
                case "NetConnection.Connect.Failed":
                {
                    this.Play();
                    this.state = 1;
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadNetClosed");
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    RtmpManager.stopTalkback();
                    ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadBusy");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        function Play()
        {
            this.Stop();
            this.initConn();
            //trace("upload retry");
            return;
        }// end function

        function onResult(param1:Object) : void
        {
            return;
        }// end function

        public function Stop()
        {
            if (this._video != null)
            {
                this._video.clear();
                this._video = null;
            }
            if (this._nc != null)
            {
                this._nc.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatus);
                this._nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this._nc.removeEventListener(IOErrorEvent.IO_ERROR, this.mistake);
                this._nc.close();
            }
            if (this._ns != null)
            {
                this._ns.close();
                this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.netStatus);
                this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                this._ns.removeEventListener(IOErrorEvent.IO_ERROR, this.mistake);
            }
            this._nc = null;
            this._ns = null;
            if (this._mic != null)
            {
                this._mic.removeEventListener(StatusEvent.STATUS, this.onMicStatus);
                this._mic = null;
            }
            if (this._cam != null)
            {
                this._cam = null;
            }
            return;
        }// end function

        function getInfor(param1:Object) : void
        {
            trace("Server returning Infor: " + param1);
            return;
        }// end function

        function onState(param1:Object) : void
        {
            trace("Connection result error: " + param1);
            this.state = 1;
            return;
        }// end function

        public function setTalkParam(param1:int)
        {
            this.buffer = param1;
            if (this._ns != null)
            {
                this._ns.bufferTime = param1;
            }
            return;
        }// end function

        public function setTalkMaxParam(param1:int)
        {
            this.bufferMax = param1;
            if (this._ns != null)
            {
                this._ns.bufferTimeMax = param1;
            }
            return;
        }// end function

    }
}
