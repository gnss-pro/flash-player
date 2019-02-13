package com.flv
{
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;

    public class language extends EventDispatcher
    {
        public var pausTxt:String = "暂停";
        public var playTxt:String = "播放";
        public var stopTxt:String = "停止";
        public var fastPre:String = "快退";
        public var fastNxt:String = "快进";
        public var disableSound:String = "静音";
        public var enableSound:String = "取消静音";
        public var full:String = "全屏";
        public var norm:String = "正常";
        public var loading:String = "正在缓冲";
        public var connect:String = "正在连接";
        public var connectError:String = "无法连接";
        public var offLine:String = "当前设备不在线";
        public var waiting:String = "";
        public var capTxt:String = "抓取图像";
        var ld:URLLoader;

        public function language() : void
        {
            this.ld = new URLLoader();
            this.ld.addEventListener(Event.COMPLETE, this.cmp);
            ExternalInterface.addCallback("setLanguage", this.setLanguage);
            return;
        }// end function

        public function setLanguage(param1:String) : void
        {
            var _loc_2:* = new URLRequest(param1);
            this.ld.load(_loc_2);
            return;
        }// end function

        function cmp(event:Event) : void
        {
            var _loc_2:* = XML(this.ld.data);
            this.pausTxt = _loc_2.attribute("pausTxt");
            this.playTxt = _loc_2.attribute("playTxt");
            this.stopTxt = _loc_2.attribute("stopTxt");
            this.fastPre = _loc_2.attribute("fastPre");
            this.fastNxt = _loc_2.attribute("fastNxt");
            this.disableSound = _loc_2.attribute("disableSound");
            this.enableSound = _loc_2.attribute("enableSound");
            this.full = _loc_2.attribute("full");
            this.norm = _loc_2.attribute("norm");
            this.loading = _loc_2.attribute("loading");
            this.connect = _loc_2.attribute("connect");
            this.connectError = _loc_2.attribute("connectError");
            this.offLine = _loc_2.attribute("offLine");
            this.waiting = _loc_2.attribute("waiting");
            this.capTxt = _loc_2.attribute("captxt");
            dispatchEvent(new langEvent());
            return;
        }// end function

    }
}
