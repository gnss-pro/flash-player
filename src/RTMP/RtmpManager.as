package RTMP
{

    public class RtmpManager extends Object
    {
        static var RM:RTMPMain = new RTMPMain();
        static var isListen:Boolean = false;
//        public static var listenUrlManager:UrlManager;
//        public static var talkUrlManager:UrlManager;
        public static var listenerServerId:Object;
        public static var listenerServerPort:Object;
        public static var talkServerId:Object;
        public static var talkServerPort:Object;

        public function RtmpManager()
        {
            return;
        }// end function

        public static function startListen(param1:String)
        {
            RM.startListen(param1);
            return;
        }// end function

        public static function stopListen()
        {
//            if (listenUrlManager != null)
//            {
//                listenUrlManager.Stop();
//            }
            listenerServerId = -1;
            listenerServerPort = -1;
            RM.stopListen();
            return;
        }// end function

        public static function getListenState()
        {
            return RM.getListenState();
        }// end function

        public static function getTalkbackState() : int
        {
            return RM.getTalkbackState();
        }// end function

        public static function setListenParam(param1:int) : int
        {
            return RM.setListenParam(param1);
        }// end function

        public static function setTalkParam(param1:int) : int
        {
            return RM.setTalkParam(param1);
        }// end function

        public static function setTalkMaxParam(param1:int) : int
        {
            return RM.setTalkMaxParam(param1);
        }// end function

//        public static function startTalk(param1:String, param2:String) : int
//        {
//            var _loc_3:* = "http" + param2.substring(4);
//            var _loc_4:* = RM.startTalk(param2, "");
//            if (_loc_4 == 0)
//            {
//                RM.startRecive(_loc_3);
//            }
//            return _loc_4;
//        }// end function
		
		public static function startTalk(ip:String,port:int,sim:String) : int
		{
			var _loc_3:* = "http://"+ip+":"+port+"/realstream?fmt=flv&vchn=-1&vstreamtype=1&achn=-1&atype=0&datatype=1&phone="+sim;
			var _loc_4:* = RM.startTalk(ip,port,sim);
			if (_loc_4 == 0)
			{
				RM.startRecive(_loc_3);
			}
			return _loc_4;
		}
		
        public static function stopTalkback()
        {
//            if (talkUrlManager != null)
//            {
//                talkUrlManager.Stop();
//            }
            talkServerId = -1;
            RM.stopTalkback();
            RM.stopRecive();
            return;
        }// end function

        public static function reStartListen()
        {
//            listenUrlManager.getUrl1();
			RM.listener.Play();
            return;
        }// end function

        public static function reStartTalk()
        {
//            talkUrlManager.getUrl1();
			RM.reciver.Play();
            return;
        }// end function

    }
}
