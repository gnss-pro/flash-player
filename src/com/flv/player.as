package com.flv
{
    import com.adobe.images.PNGEncoder;
    
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Matrix;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.FileReference;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.system.Security;
    import flash.utils.Timer;
    

    public class player extends MovieClip
    {
//		[Embed(source="../images/loading.swf")]  
//		[Bindable]    
//		var normal:Class;
		
		public var videoConnection:NetConnection;
        public var videoStream:NetStream;
        public var video:Video;
        var metaListener:Object;
        public var flvurl:String = "";
        public var Rect:RECT;
        public var _duration:Number;
        public var vol:Number;
        public var vol1:Number;
        public var isvol:Boolean;
        public var ispaus:Boolean;
        public var isfull:Boolean;
        public var iswait:Boolean;
        public var id:int;
        public var BtnPlay:VideoBtn;
        public var backStat:Boolean;
        var oldBytes:Number = 0;
        var vodBorder:border;
//        var ldinfo:loading;
        var vodLogo:logo;
        var msg:info;
        public var param:String = "";
        public var flvstat:int;
        var CtrlPan:VideoCtrl;
        public var WH:String = "full";
        var timer:Timer;
        var dbClickMC:ClickMC;
//        public var serverIP:String = "";
//        public var serverPort:String = "";
//        public var serverId:int = -1;
        public var Menu:Array;
        public var urlParm:UrlParm;
		
		
        public function player() : void
        {
            this.timer = new Timer(500);
            this.urlParm = new UrlParm();
            this.doubleClickEnabled = true;
            this.Menu = new Array();
            this.video = new Video();
            this.videoConnection = new NetConnection();
            this.videoConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.videoConnection.addEventListener(NetStatusEvent.NET_STATUS, this.nstat);
            this.videoConnection.connect(null);
            this.videoConnection.maxPeerConnections = 100;
            this.videoStream = new NetStream(this.videoConnection);
            this.videoStream.bufferTime = 0.1;
            this.videoStream.addEventListener(NetStatusEvent.NET_STATUS, this.nstat);
            this.videoStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this.videoStream.addEventListener(IOErrorEvent.IO_ERROR, this.mistake);
            this.video.attachNetStream(this.videoStream);
            addChild(this.video);
            this.metaListener = new Object();
            this.metaListener.onMetaData = this.onMetaData;
            this.videoStream.client = this.metaListener;
            this.isvol = true;
            this.ispaus = true;
            this.isfull = false;
            this.iswait = true;
            var _loc_1:* = 1;
            this.vol = 1;
            this.vol1 = _loc_1;
            this.flvstat = 0;
            this._duration = 0;
//            this.ldinfo = new loading();
            this.vodLogo = new logo();
            this.vodLogo.x = this.video.x;
            this.vodLogo.y = this.video.y;
            addChild(this.vodLogo);
//            addChild(this.ldinfo);
            this.CtrlPan = new VideoCtrl();
            this.CtrlPan.addEventListener(playEvent.PLAY, this.onPlay);
            this.CtrlPan.addEventListener(playEvent.STOP, this.onStop);
            this.CtrlPan.addEventListener(playEvent.FULL, this.onFull);
            this.CtrlPan.addEventListener(playEvent.NORM, this.onNorm);
//            this.CtrlPan.addEventListener(playEvent.SOUND, this.onSound);
//            this.CtrlPan.addEventListener(playEvent.SILENT, this.onSilent);
            this.CtrlPan.addEventListener(playEvent.CAPTURE, this.onCapture);
            this.vodBorder = new border();
            addChildAt(this.vodBorder, 0);
            this.msg = new info();
            addChild(this.msg);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.BtnPlay = new VideoBtn();
            this.BtnPlay.addEventListener(playEvent.PLAY, this.onPlay);
            this.dbClickMC = new ClickMC();
            this.dbClickMC.visible = true;
            addChild(this.dbClickMC);
            this.dbClickMC.addEventListener(MouseEvent.DOUBLE_CLICK, this.dbclick);
            this.dbClickMC.addEventListener(MouseEvent.CLICK, this.fclick);
            addChild(this.BtnPlay);
            addChild(this.CtrlPan);
            return;
        }// end function

        function onTimer(event:Event)
        {
            var _loc_2:* = this.videoStream.bytesLoaded;
            var _loc_3:* = (_loc_2 - this.oldBytes) / 512;
            this.CtrlPan.setBps(_loc_3);
            this.oldBytes = _loc_2;
            return;
        }// end function

        public function setBufferTime(param1:Number) : void
        {
            this.videoStream.bufferTime = param1;
            return;
        }// end function

        function onPlay(event:playEvent) : void
        {
            this.Play();
            return;
        }// end function

        function onCapture(event:playEvent)
        {
            var m:Matrix;
            var e:* = event;
            dispatchEvent(new playEvent("norm"));
            var bmpd:* = new BitmapData(320, 240);
            try
            {
                m = new Matrix();
                m.tx = this.video.x;
                m.ty = this.video.y;
                bmpd.draw(this.video);
            }
            catch (e:Error)
            {
                ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "PicSave-error" + e.message);
                return;
            }
            var imgByteArray:* = PNGEncoder.encode(bmpd);
            var FileRefe:* = new FileReference();
            ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "PicSave");
            var date:* = new Date();
            var info:*;
            if (this.CtrlPan.info != "")
            {
                info = this.CtrlPan.info + "-";
            }
            var s:* = info + date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate() + " " + date.getHours() + "-" + date.getMinutes() + "-" + date.getSeconds() + ".png";
            FileRefe.save(imgByteArray, s);
            return;
        }// end function

        function onPause(event:playEvent) : void
        {
            if (this.iswait)
            {
                return;
            }
            this.Paus();
            return;
        }// end function

        function onStop(event:playEvent) : void
        {
            this.Stop();
            return;
        }// end function

        function onFull(event:playEvent) : void
        {
            dispatchEvent(new playEvent("full"));
            return;
        }// end function

        function onNorm(event:playEvent) : void
        {
            dispatchEvent(new playEvent("norm"));
            return;
        }// end function

//        function onSound(event:playEvent) : void
//        {
//            this.ablevol();
//            if (this.iswait)
//            {
//                return;
//            }
//            dispatchEvent(new playEvent("sound"));
//            return;
//        }// end function
//
//        function onSilent(event:playEvent) : void
//        {
//            this.disvol();
//            return;
//        }// end function

        function onMSover(event:MouseEvent) : void
        {
            this.CtrlPan.visible = true;
            return;
        }// end function

        function onMSout(event:MouseEvent) : void
        {
            this.CtrlPan.visible = false;
            return;
        }// end function

        function fclick(event:MouseEvent) : void
        {
            if (this.isfull)
            {
                return;
            }
            trace("click player");
            dispatchEvent(new playerEvent("pclick"));
            return;
        }// end function

        public function playFLV(param1:String) : void
        {
            this.flvurl = param1;
            trace("playVideo " + param1);
            this._duration = 0;
//            var _loc_2:* = this.flvurl.substr(0, this.flvurl.lastIndexOf("/")) + "/crossdomain.xml";
//            Security.loadPolicyFile(_loc_2);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
            this.iswait = false;
            this.ispaus = false;
            if (this.vodBorder.stat == border.waitfull)
            {
                this.vodBorder.stat = border.full;
            }
            this.vodBorder.updateBG();
            this.msg.visible = false;
            this.video.clear();
            this.videoStream.play(this.flvurl);
            this.addEventListener(Event.ENTER_FRAME, this.refreshBuffer);
            this.timer.start();
            this.CtrlPan.bp.onPlay();
            this.CtrlPan.enable();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "start");
            this.BtnPlay.visible = false;
            this.dbClickMC.Hide();
            return;
        }// end function

        public function setNorm() : void
        {
            this.isfull = false;
            this.reSize();
            return;
        }// end function

        public function setFull() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            if (this.WH == "full")
            {
//                this.video.x = 275 - this.Rect.sw / 2;
//                this.video.y = 200 - this.Rect.sh / 2;
				this.video.x = 1;
				this.video.y = 1;
                this.video.width = this.Rect.sw;
                this.video.height = this.Rect.sh - 30;
            }
            else
            {
                _loc_1 = this.WH.split(":");
                _loc_2 = int(_loc_1[0]);
                _loc_3 = int(_loc_1[1]);
                if (this.Rect.sw / (this.Rect.sh - 30) >= _loc_2 / _loc_3)
                {
                    this.video.height = this.Rect.sh - 30;
                    this.video.width = _loc_2 * this.video.height / _loc_3;
                    this.video.x = (550 - this.video.width) / 2;
                    this.video.y = (400 - this.video.height) / 2 - 15;
                }
                else
                {
                    this.video.width = this.Rect.sw;
                    this.video.height = _loc_3 * this.video.width / _loc_2;
                    this.video.x = (550 - this.video.width) / 2;
                    this.video.y = (400 - this.video.height) / 2 - 15;
                }
            }
            this.isfull = true;
            if (this.iswait)
            {
                this.vodBorder.stat = border.waitfull;
            }
            else
            {
                this.vodBorder.stat = border.full;
            }
            this.vodBorder.updateBG();
            this.msg.isfull = true;
            this.msg.reSize();
            this.CtrlPan.isFull = true;
            this.CtrlPan.reSize();
            this.vodLogo.isFull = true;
            this.vodLogo.reSize();
//            this.ldinfo.isfull = true;
//            this.ldinfo.reSize();
            this.BtnPlay.isFull = true;
            this.BtnPlay.reSize();
            this.dbClickMC.isFull = true;
            this.dbClickMC.reSize();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "full");
            return;
        }// end function

        public function setVideoTbarBgColor(param1:String) : void
        {
            this.CtrlPan.setColor(param1);
            return;
        }// end function

        function refreshBuffer(event:Event) : void
        {
            var _loc_2:* = Math.round(100 * this.videoStream.bufferLength / this.videoStream.bufferTime);
            if (_loc_2 > 100)
            {
                _loc_2 = 100;
            }
//            this.ldinfo.ldinfo.text = _loc_2 + "%";
            if (this.ispaus)
            {
//                this.ldinfo.visible = false;
            }
            else
            {
//                this.ldinfo.visible = true;
            }
            return;
        }// end function

        function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            trace("SecurityErrorEvent" + event);
//            this.ldinfo.visible = false;
            this.msg.showMsg("connectError");
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "neterror");
            return;
        }// end function

        function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            trace("AsyncErrorEvent" + event);
//            this.ldinfo.visible = false;
            this.msg.showMsg("connectError");
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "neterror");
            return;
        }// end function

        public function showLoading()
        {
//            this.ldinfo.visible = true;
            this.iswait = false;
            this.vodBorder.updateBG();
            this.CtrlPan.bp.onPlay();
            this.CtrlPan.enable();
//            this.ldinfo.play();
            return;
        }// end function

        public function hideLoading()
        {
//            this.ldinfo.visible = false;
            this.BtnPlay.visible = true;
            this.CtrlPan.bp.onPlay();
            return;
        }// end function

        function nstat(event:NetStatusEvent) : void
        {
            trace("playVideo " + event.info.code);
            if (this.iswait)
            {
                return;
            }
            switch(event.info.code)
            {
                case "NetStream.Buffer.Empty":
                {
//                    this.ldinfo.visible = true;
//                    this.ldinfo.play();
                    this.addEventListener(Event.ENTER_FRAME, this.refreshBuffer);
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.removeEventListener(Event.ENTER_FRAME, this.refreshBuffer);
//                    this.ldinfo.visible = false;
                    break;
                }
                case "NetStream.Play.Failed":
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Play.Stop":
                {
                    this.ispaus = true;
//                    this.ldinfo.visible = false;
                    this.msg.showMsg("connectError");
                    this.Play();
                    trace("retry");
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
            this.ispaus = true;
//            this.ldinfo.visible = false;
            this.msg.showMsg("connectError");
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "videoerror");
            return;
        }// end function

        function mistake(event:IOErrorEvent) : void
        {
            this.ispaus = true;
//            this.ldinfo.visible = false;
            this.msg.showMsg("connectError");
            this.Play();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "videoerror");
            return;
        }// end function

        function dbclick(event:MouseEvent) : void
        {
            dispatchEvent(new playerEvent("pdoubleclick"));
            return;
        }// end function

        function onMetaData(param1:Object) : void
        {
            this._duration = param1.duration;
            dispatchEvent(new playerEvent("alltime"));
            return;
        }// end function

        public function reSize() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            if (this.isfull)
            {
                this.setFull();
            }
            else
            {
                if (this.WH == "full")
                {
                    this.video.x = this.Rect.rx;
                    this.video.y = this.Rect.ry;
                    this.video.width = this.Rect.rw;
                    this.video.height = this.Rect.rh - 30;
                }
                else
                {
                    _loc_1 = this.WH.split(":");
                    _loc_2 = int(_loc_1[0]);
                    _loc_3 = int(_loc_1[1]);
                    if (this.Rect.rw / (this.Rect.rh - 30) >= _loc_2 / _loc_3)
                    {
                        this.video.height = this.Rect.rh - 30;
                        this.video.width = _loc_2 * this.video.height / _loc_3;
                        this.video.x = this.Rect.rx + (this.Rect.rw - this.video.width) / 2;
                        this.video.y = this.Rect.ry + (this.Rect.rh - this.video.height - 30) / 2;
                    }
                    else
                    {
                        this.video.width = this.Rect.rw;
                        this.video.height = _loc_3 * this.video.width / _loc_2;
                        this.video.x = this.Rect.rx + (this.Rect.rw - this.video.width) / 2;
                        this.video.y = this.Rect.ry + (this.Rect.rh - this.video.height - 30) / 2;
                    }
                }
                this.vodBorder.rsSize();
                this.msg.isfull = false;
                this.msg.reSize();
                this.CtrlPan.isFull = false;
                this.CtrlPan.reSize();
                this.vodLogo.isFull = false;
                this.vodLogo.reSize();
//                this.ldinfo.isfull = false;
//                this.ldinfo.reSize();
                this.BtnPlay.isFull = false;
                this.BtnPlay.reSize();
                this.dbClickMC.isFull = false;
                this.dbClickMC.reSize();
            }
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.video.x = param1.rx;
            this.video.y = param1.ry;
            this.video.width = param1.rw;
            this.video.height = param1.rh;
			trace(param1.rx+","+param1.ry+";"+param1.rw+","+param1.rh);
            this.Rect = param1;
            this.vodBorder.setRect(this.Rect);
//            this.ldinfo.setRect(this.Rect);
//            this.ldinfo.visible = false;
            this.msg.setRect(this.Rect);
            this.msg.visible = true;
            if (this.iswait)
            {
                this.msg.showMsg("waiting");
            }
            this.CtrlPan.setRect(this.Rect);
            this.CtrlPan.reSize();
            this.vodLogo.setRect(this.Rect);
            this.vodLogo.reSize();
            this.BtnPlay.setRect(this.Rect);
            this.BtnPlay.reSize();
            this.dbClickMC.setRect(this.Rect);
            this.dbClickMC.reSize();
            return;
        }// end function

        public function setLogoTxt(param1:String, param2:Number, param3:int, param4:int, param5:int) : void
        {
            this.vodLogo.setTxt(param1, param2, param3, param4, param5);
            return;
        }// end function

        public function showBorder() : void
        {
            if (!this.isfull)
            {
                if (this.iswait)
                {
                    this.vodBorder.stat = border.waitsel;
                }
                else
                {
                    this.vodBorder.stat = border.sel;
                }
                this.vodBorder.updateBG();
            }
            return;
        }// end function

        public function hideBorder() : void
        {
            if (this.iswait)
            {
                this.vodBorder.stat = border.wait;
            }
            else
            {
                this.vodBorder.stat = border.norm;
            }
            this.vodBorder.updateBG();
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            this.vol = param1;
            var _loc_2:* = new SoundTransform();
            _loc_2.volume = this.vol;
            this.videoStream.soundTransform = _loc_2;
            return;
        }// end function

//        public function disvol() : void
//        {
//            this.vol1 = this.vol;
//            this.vol = 0;
//            var _loc_1:* = new SoundTransform();
//            _loc_1.volume = this.vol;
//            this.videoStream.soundTransform = _loc_1;
//            this.isvol = false;
//            this.CtrlPan.bs.silent();
//            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "silent");
//            return;
//        }// end function
//
//        public function ablevol() : void
//        {
//            var _loc_2:* = 1;
//            this.vol1 = 1;
//            this.vol = _loc_2;
//            var _loc_1:* = new SoundTransform();
//            _loc_1.volume = this.vol;
//            this.videoStream.soundTransform = _loc_1;
//            this.isvol = true;
//            this.CtrlPan.bs.sound();
//            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "sound");
//            return;
//        }// end function

        public function Paus() : void
        {
            if (this.iswait)
            {
                return;
            }
            if (this.ispaus == false)
            {
                this.videoStream.togglePause();
                this.ispaus = true;
            }
            this.BtnPlay.visible = true;
			this.CtrlPan.bp.disable();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "paus");
            return;
        }// end function

        public function Play() : void
        {
//            this.serverIP = "";
//            this.serverPort = "";
//            this.serverId = -1;
//            if (this.urlManager != null)
//            {
//                this.showLoading();
//                this.urlManager.getUrl1();
//                this.urlManager.retry = true;
//            }
//            else
//            {
//            }
			this.videoStream.close();
            this.playFLV(this.flvurl);
            this.timer.start();
            this.dbClickMC.Hide();
            this.BtnPlay.visible = false;
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "play");
            return;
        }// end function

        public function Stop() : void
        {
            if (this.iswait)
            {
                return;
            }
            this.hideLoading();
//            if (this.urlManager != null)
//            {
//                this.urlManager.Stop();
//            }
//            this.serverId = -1;
//            this.serverPort = "";
            this.videoStream.close();
            this._duration = 0;
            this.dbClickMC.Show();
            this.BtnPlay.visible = true;
            this.iswait = true;
            this.ispaus = true;
            if (this.isfull)
            {
                this.vodBorder.stat = border.waitfull;
            }
            this.vodBorder.updateBG();
            this.timer.stop();
            this.CtrlPan.showInfo();
            this.removeEventListener(Event.ENTER_FRAME, this.refreshBuffer);
//            this.ldinfo.visible = false;
            this.msg.showMsg("");
            this.msg.visible = false;
//            this.disvol();
//            this.CtrlPan.bs.disable();
            this.CtrlPan.bp.onStop();
            this.CtrlPan.bp.enable();
            this.CtrlPan.bc.disable();
            ExternalInterface.call("onTtxVideoMsg", "" + this.id + "", "stop");
            return;
        }// end function

        public function gotoPos(param1:Number) : void
        {
            if (this._duration == 0)
            {
                return;
            }
            this.videoStream.seek(param1);
            return;
        }// end function

        public function getPos() : Number
        {
            var _loc_1:* = this.videoStream.time;
            return _loc_1;
        }// end function

        public function updateUiText(param1:language) : void
        {
//            this.ldinfo.loadingTxt.text = param1.loading;
            this.msg.updateUiText(param1);
            this.CtrlPan.updateUiText();
            return;
        }// end function

        public function updatePic(param1:config) : void
        {
            this.vodLogo.updatePic(param1);
            this.vodBorder.updatePic(param1);
            return;
        }// end function

        public function setLogo(param1:String, param2:int, param3:int) : void
        {
            this.vodLogo.setLogo(param1, param2, param3);
            return;
        }// end function

        public function setVideoInfo(param1:String) : void
        {
            this.CtrlPan.info = param1;
            this.CtrlPan.showInfo();
            return;
        }// end function

        public function addMenu(param1:String, param2:String, param3:int) : int
        {
            var _loc_4:* = 0;
            while (_loc_4 < this.Menu.length)
            {
                
                if (this.Menu[_loc_4].menuId == param1)
                {
                    return 5;
                }
                _loc_4 = _loc_4 + 1;
            }
            var _loc_5:* = new MenuItem(param1, param2, param3, this.id);
            this.Menu.push(_loc_5);
            return 0;
        }// end function

        public function delMenu(param1:String) : int
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.Menu.length)
            {
                
                if (this.Menu[_loc_2].menuId == param1)
                {
                    this.Menu[_loc_2].del();
                    this.Menu.splice(_loc_2, 1);
                    return 0;
                }
                _loc_2 = _loc_2 + 1;
            }
            return 5;
        }// end function

        public function clearMenu() : int
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.Menu.length)
            {
                
                this.Menu[_loc_1].del();
                _loc_1 = _loc_1 + 1;
            }
            this.Menu = new Array();
            return 0;
        }// end function

        public function reSet()
        {
            this.removeEventListener(Event.ENTER_FRAME, this.refreshBuffer);
            this.timer.stop();
//            this.ldinfo.visible = false;
            this.CtrlPan.disable();
            this.BtnPlay.visible = false;
//            if (this.urlManager != null)
//            {
//                this.urlManager.Stop();
//            }
//            this.serverId = -1;
//            this.serverPort = "";
            this.videoStream.close();
            this.video.clear();
            this.ispaus = false;
            this.isfull = false;
            this.iswait = true;
            var _loc_1:* = 1;
            this.vol = 1;
            this.vol1 = _loc_1;
            this.flvstat = 0;
            this._duration = 0;
            this.BtnPlay.visible = false;
            this.vodLogo.reSet();
            this.dbClickMC.Hide();
            this.CtrlPan.reSet();
            this.vodBorder.updateBG();
            return;
        }// end function

    }
}
