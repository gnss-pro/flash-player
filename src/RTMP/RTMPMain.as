package RTMP
{
    import flash.display.Sprite;
    
    import MRecord.MicrophoneRecorder;
    

    public class RTMPMain extends Sprite
    {
//        var publisher:MicRecord;
		var publisher:MicrophoneRecorder;
        var listener:Listener;
        var reciver:Reciver2;
        var bufferListen:int = 0;
        var bufferTalk:int = 0;
        var bufferTalkMax:int = 1;

        public function RTMPMain()
        {
            return;
        }// end function

        public function setListenParam(param1:int) : int
        {
            this.bufferListen = param1;
            if (this.listener != null)
            {
                this.listener.setListenParam(param1);
            }
            return 0;
        }// end function

        public function setTalkParam(param1:int) : int
        {
            this.bufferTalk = param1;
            if (this.publisher != null)
            {
//                this.publisher.setTalkParam(param1);
                this.reciver.setTalkParam(param1);
            }
            return 0;
        }// end function

        public function setTalkMaxParam(param1:int) : int
        {
            this.bufferTalkMax = param1;
            if (this.publisher != null)
            {
//                this.publisher.setTalkMaxParam(param1);
            }
            return 0;
        }// end function

        public function getListenState()
        {
            if (this.listener == null)
            {
                return 2;
            }
            return this.listener.state;
        }// end function

        public function getTalkbackState() : int
        {
            if (this.publisher == null)
            {
                return 2;
            }
            var _loc_1:* = this.reciver.state;
            var _loc_2:* = this.publisher.state;
            var _loc_3:* = 100 + _loc_1 * 10 + _loc_2;
            return _loc_3;
        }// end function

        public function startListen(param1:String, param2 = "", param3:int = 320, param4:int = 240)
        {
            if (this.listener != null)
            {
                this.listener.Stop();
                this.listener = null;
            }
            this.listener = new Listener(param1);
            this.listener.setListenParam(this.bufferListen);
            return;
        }// end function

        public function startRecive(param1:String, param2 = "", param3:int = 320, param4:int = 240)
        {
            if (this.reciver != null)
            {
                this.reciver.Stop();
                this.reciver = null;
            }
            this.reciver = new Reciver2(param1);
            this.reciver.setTalkParam(this.bufferTalk);
            return;
        }// end function

        public function stopListen()
        {
            if (this.listener == null)
            {
                return;
            }
            this.listener.Stop();
            this.listener = null;
            return;
        }// end function

        public function stopRecive()
        {
            if (this.reciver == null)
            {
                return;
            }
            this.reciver.Stop();
            this.reciver = null;
            return;
        }// end function

        public function stopTalkback()
        {
            if (this.publisher == null)
            {
                return;
            }
            this.publisher.Stop();
            this.publisher = null;
            return;
        }// end function

//        function startTalk(param1:String, param2 = "") : int
//        {
//            if (this.publisher != null)
//            {
//                return 1;
//            }
//            this.publisher = new Publisher(param1, param2);
//            var _loc_3:* = this.publisher.checkMic();
//            if (_loc_3 == 1)
//            {
//                trace("mic falid");
//                this.publisher = null;
//                return 2;
//            }
//            if (_loc_3 == 2)
//            {
//                trace("mic denied");
//                this.publisher = null;
//                return 3;
//            }
//            this.publisher.setTalkParam(this.bufferTalk);
//            return 0;
//        }// end function
		public function startTalk(ip:String, port:int, sim:String) : int{
//			this.publisher = new MicRecord(ip,port,sim);
			this.publisher = new MicrophoneRecorder(ip,port,sim);
			publisher.Start();
			return 0;
		}
    }
}
