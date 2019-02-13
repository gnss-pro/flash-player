package com.flv
{
    import com.flv.RectManager;
    import com.flv.language;
    import com.flv.player;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
    import flash.media.Microphone;
    import flash.net.FileReference;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    
    import RTMP.MicRecord;
    import RTMP.RtmpManager;
    

    public class main extends MovieClip
    {
//		public var tool:tools = new tools();
		var num:int;
        var vod:Array;
        var rect:Array;
        var currVod:player;
        var lang:language;
        var serverIP:String = "";
        var serverPort:String = "";
        var cfg:config;
        var _contextMenu:ContextMenu;
        private var version:String = "20170630";
        private var ver:String = "1.0.4";
        private var VerMenu:ContextMenuItem;
		private var CopyRight:ContextMenuItem;
		private var _stageSizeTimer:Timer;
		
        public function main() : void
        {
			_stageSizeTimer = new Timer(250);
			_stageSizeTimer.addEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }// end function
		
		private function onAddedToStage(e:Event):void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_stageSizeTimer.start();
		}
		
		private function onStageSizeTimerTick(e:TimerEvent):void{
			if(stage.stageWidth > 0 && stage.stageHeight > 0){
				_stageSizeTimer.stop();
				_stageSizeTimer.removeEventListener(TimerEvent.TIMER, onStageSizeTimerTick);
				init();
			}
		}

		private function init():void{
			this.vod = new Array();
			this.rect = new Array();
			this._contextMenu = new ContextMenu();
			this.VerMenu = new ContextMenuItem("sbh " + this.ver + " " + this.version);
			var date:Date=new Date(); //获取时间  
			var year:int=date.fullYear; //获取年份  
			this.CopyRight = new ContextMenuItem("Copyright © "+year+" ICarThinking. All right reserved.");
			this.VerMenu.separatorBefore = true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.initEvent();
			this.initAPI();
			this.resizeVod();
			RectManager.stage = stage;
//			addChild(tool);
		}
		

        function winSize(event:Event) : void
        {
//            this.tool.changeSize();
            this.resizeVod();
            return;
        }// end function

        function fplay(event:playEvent) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            if (this.currVod == null)
            {
                return;
            }
            if (this.currVod.iswait && this.currVod.flvstat > 0)
            {
                if (this.currVod.flvstat == 1)
                {
                    _loc_2 = new Date();
                    _loc_3 = "http://" + this.serverIP + ":" + this.serverPort + "/rtmp/" + _loc_2.getTime() + "/?" + this.currVod.param;
                    this.currVod.playFLV(_loc_3);
//                    this.tool.setVod(this.currVod);
                }
                else if (this.currVod.flvstat == 2)
                {
                    this.currVod.playFLV(this.currVod.flvurl);
//                    this.tool.setVod(this.currVod);
                }
            }
            else
            {
                this.currVod.Play();
            }
            return;
        }// end function

        function fpaus(event:playEvent) : void
        {
            if (this.currVod == null)
            {
                return;
            }
            if (this.currVod.iswait)
            {
                return;
            }
            this.currVod.Paus();
            return;
        }// end function

        function ffull(event:playEvent) : void
        {
            stage.displayState = StageDisplayState.FULL_SCREEN;
            return;
        }// end function

        function fnorm(event:playEvent) : void
        {
            stage.displayState = StageDisplayState.NORMAL;
            return;
        }// end function

//        function fvol(event:volEvent) : void
//        {
//            this.currVod.setVolume(event.vol);
//            return;
//        }// end function
//
//        function tim(event:timeEvent) : void
//        {
//            this.currVod.gotoPos(event.tim);
//            return;
//        }// end function

        function fstop(event:playEvent) : void
        {
            if (this.currVod == null)
            {
                return;
            }
            if (this.currVod.iswait)
            {
                return;
            }
            this.currVod.Stop();
//            this.tool.setVod(this.currVod);
            return;
        }// end function


        function initEvent() : void
        {
            this.lang = new language();
            this.lang.addEventListener(langEvent.CHANGE, this.updateUiText);
            this.cfg = new config();
            this.cfg.addEventListener(configEvent.CHANGE, this.setPIC);
            Common.lang = this.lang;
            Common.cfg = this.cfg;
            stage.addEventListener(Event.RESIZE, this.winSize);
//            stage.addEventListener(Event.MOUSE_LEAVE, this.msLeave);
//            stage.addEventListener(MouseEvent.MOUSE_OVER, this.msOver);
//            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopdrag);
//            this.tool.addEventListener(timeEvent.TIME, this.tim);
//            this.tool.addEventListener(volEvent.VOL, this.fvol);
//            this.tool.addEventListener(playEvent.FULL, this.ffull);
//            this.tool.addEventListener(playEvent.NORM, this.fnorm);
//            this.tool.addEventListener(playEvent.PLAY, this.fplay);
//            this.tool.addEventListener(playEvent.PAUS, this.fpaus);
//            this.tool.addEventListener(playEvent.STOP, this.fstop);
            this._contextMenu.hideBuiltInItems();
            this.contextMenu = this._contextMenu;
            this._contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, this.clickMenu);
            return;
        }// end function
		
        function initAPI() : void
        {
            ExternalInterface.addCallback("setLogoTxt", this.setLogoTxt);
            ExternalInterface.addCallback("startVod", this.startVideo);
            ExternalInterface.addCallback("stopVideo", this.stopVideo);
            ExternalInterface.addCallback("setWindowNum", this.setWindowNum);
            ExternalInterface.addCallback("setServerInfo", this.setServerInfo);
            ExternalInterface.addCallback("setVideoServer", this.setVideoServer);
            ExternalInterface.addCallback("startVideo", this.startVod);
			ExternalInterface.addCallback("resetTalk", this.resetTalk);
            ExternalInterface.addCallback("pauseVideo", this.pauseVideo);
            ExternalInterface.addCallback("getVersion", this.getVersion);
            ExternalInterface.addCallback("setVideoInfo", this.setVideoInfo);
            ExternalInterface.addCallback("setVideoFrame", this.setVideoFrame);
            ExternalInterface.addCallback("setBufferTime", this.setBufferTime);
            ExternalInterface.addCallback("reSetVideo", this.reSetVideo);
            ExternalInterface.addCallback("setVideoFocus", this.setVideoFocus);
            ExternalInterface.addCallback("startListen", this.startListen);
            ExternalInterface.addCallback("stopListen", this.stopListen);
            ExternalInterface.addCallback("getListenState", this.getListenState);
            ExternalInterface.addCallback("getTalkbackState", this.getTalkbackState);
            ExternalInterface.addCallback("setListenParam", this.setListenParam);
            ExternalInterface.addCallback("setTalkParam", this.setTalkParam);
            ExternalInterface.addCallback("setTalkMaxParam", this.setTalkMaxParam);
            ExternalInterface.addCallback("startTalkback", this.startTalkback);
            ExternalInterface.addCallback("stopTalkback", this.stopTalkback);
            ExternalInterface.addCallback("setVideoTbarBgColor", this.setVideoTbarBgColor);
            ExternalInterface.addCallback("getVideoPlayTime", this.getVideoPlayTime);
            ExternalInterface.addCallback("addVideoMenu", this.addVideoMenu);
            ExternalInterface.addCallback("delVideoMenu", this.delVideoMenu);
            ExternalInterface.addCallback("clearVideoMenu", this.clearVideoMenu);
            return;
        }// end function

        public function startTalkback(param1:String, param2:String, param3:String, param4:String = "", param5:int = 0) : int
        {
            var m:*;
            var session:* = param1;
            var devIdno:* = param2;
            var channel:* = param3;
            var server:* = param4;
            var port:* = param5;
            var sip:* = this.serverIP;
            var sport:* = this.serverPort;
            if (server != "")
            {
                sip = server;
            }
            if (port != "")
            {
                sport = port;
            }
            if (sip == "" || sport == "")
            {
                return 1;
            }
            if (RtmpManager.getTalkbackState() != 2 && RtmpManager.getTalkbackState() != 100)
            {
                return 4;
            }
            try
            {
                m = Microphone.getMicrophone();
                if (m.muted)
                {
                    return 3;
                }
            }
            catch (e:Event)
            {
                return 2;
            }
            var urlParm:* = new UrlParm();
            urlParm.Channel = channel;
            urlParm.DevIdno = devIdno;
            urlParm.ServerIp = sip;
            urlParm.ServerPort = sport;
            urlParm.Session = session;
            urlParm.AvType = 3;
            urlParm.MediaType = 1;
            RtmpManager.talkServerId = -1;
            RtmpManager.talkServerPort = -1;
//            var um:UrlManager;
//            if (RtmpManager.talkUrlManager == null)
//            {
//                um = new UrlManager(this.vod, sip);
//                RtmpManager.talkUrlManager = um;
//                um.addEventListener(UrlEvent.GETURL, function (param1)
//            {
//                var _loc_2:* = new Date();
//                var _loc_3:* = param1.um.Session + ",1," + param1.um.DevIdno + "," + param1.um.Channel + ",0,0,10";
//                var _loc_4:* = "rtmp://" + param1.ServerIp + ":" + param1.Port + "/rtmp/" + _loc_2.getTime() + "/?" + Base64.encode(_loc_3);
//                stopListen();
//                disAllSound();
//                RtmpManager.talkServerId = param1.ServerId;
//                RtmpManager.talkServerPort = param1.Port;
//                RtmpManager.startTalk(devIdno, _loc_4);
//                return;
//            }// end function
//            );
//            }
//            else
//            {
//                um = RtmpManager.talkUrlManager;
//            }
//            um.Stop();
//            um.getUrl(urlParm);
//			var url = "rtmp://"+server+":"+port+"/realstream?fmt=flv&vchn=-1&vstreamtype=1&achn=-1&atype=0&datatype=1&phone="+devIdno;
			stopListen();
            disAllSound();
//            RtmpManager.talkServerId = param1.ServerId;
//            RtmpManager.talkServerPort = param1.Port;
            RtmpManager.startTalk(server,port, devIdno);
            return 0;
        }// end function

        function stopTalkback()
        {
            
			RtmpManager.stopTalkback();
            return;
        }// end function

//        function msLeave(event:Event) : void
//        {
//            this.tool.visible = false;
//            return;
//        }// end function
//
//        function msOver(event:Event) : void
//        {
//            this.tool.visible = false;
//            return;
//        }// end function

        public function getVersion() : String
        {
            return this.version;
        }// end function

        public function setServerInfo(param1:String, param2:String) : int
        {
            this.serverIP = param1;
            this.serverPort = param2;
            return 0;
        }// end function

        public function setVideoServer(param1:int, param2:String, param3:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].serverIP = param2;
            this.vod[param1].serverPort = param3;
            return 0;
        }// end function

        public function setLogo(param1:int, param2:String, param3:int, param4:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].setLogo(param2, param3, param4);
            return 0;
        }// end function

        public function setLogoTxt(param1:int, param2:String, param3:Number, param4:int, param5:int, param6:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].setLogoTxt(param2, param3, param4, param5, param6);
            return 0;
        }// end function

        public function startListen(param1:String, param2:String, param3:String, param4:String = "", param5:String = "") : int
        {
            var session:* = param1;
            var devIdno:* = param2;
            var channel:* = param3;
            var server:* = param4;
            var port:* = param5;
            var sip:* = this.serverIP;
            var sport:* = this.serverPort;
            if (server != "")
            {
                sip = server;
            }
            if (port != "")
            {
                sport = port;
            }
            if (sip == "" || sport == "")
            {
                return 1;
            }
            var urlParm:* = new UrlParm();
            urlParm.Channel = channel;
            urlParm.DevIdno = devIdno;
            urlParm.ServerIp = sip;
            urlParm.ServerPort = sport;
            urlParm.Session = session;
            urlParm.AvType = 2;
            urlParm.MediaType = 1;
            RtmpManager.listenerServerId = -1;
            RtmpManager.listenerServerPort = -1;
			var url = "http://"+server+":"+port+"/realstream?fmt=flv&vchn=-1&vstreamtype=1&achn="+channel+"&atype=0&datatype=2&phone="+devIdno;
			RtmpManager.startListen(url);
            return 0;
        }// end function

        function setListenParam(param1:int) : int
        {
            return RtmpManager.setListenParam(param1);
        }// end function
//
        function setTalkParam(param1:int) : int
        {
            return RtmpManager.setTalkParam(param1);
        }// end function
//
        function setTalkMaxParam(param1:int) : int
        {
            return RtmpManager.setTalkMaxParam(param1);
        }// end function
//
        function getListenState()
        {
            return RtmpManager.getListenState();
        }// end function
//
        function getTalkbackState() : int
        {
            return RtmpManager.getTalkbackState();
        }// end function

        public function setVideoTbarBgColor(param1:int, param2:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].setVideoTbarBgColor(param2);
            return 0;
        }// end function

        function getVideoPlayTime(param1:int) : int
        {
            if (param1 < 0)
            {
                return -1;
            }
            if (this.num == 0)
            {
                return -2;
            }
            if (param1 >= this.num)
            {
                return -3;
            }
            if (this.vod[param1] == null)
            {
                return -4;
            }
            return int(this.vod[param1].getPos());
        }// end function

        public function clickMenu(event:ContextMenuEvent):void
        {
            var _loc_5:* = undefined;
            trace("rend menu");
            var _loc_2:* = mouseX;
            var _loc_3:* = mouseY;
            trace("鼠标X" + _loc_2 + "鼠标Y" + _loc_3);
            var _loc_4:* = -1;
            _loc_5 = 0;
            while (_loc_5 < this.vod.length)
            {
                
                if (this.vod[_loc_5].isfull || this.vod[_loc_5].visible && _loc_2 > this.vod[_loc_5].Rect.rx && _loc_2 < this.vod[_loc_5].Rect.rx + this.vod[_loc_5].Rect.rw && _loc_3 > this.vod[_loc_5].Rect.ry && _loc_3 < this.vod[_loc_5].Rect.ry + this.vod[_loc_5].Rect.rh)
                {
                    _loc_4 = _loc_5;
                    break;
                }
                _loc_5 = _loc_5 + 1;
            }
            ExternalInterface.call("onTtxVideoBeforePopMenu", "" + _loc_4 + "");
            var _loc_6:* = null;
            if (_loc_4 != -1)
            {
                _loc_6 = this.vod[_loc_4].Menu;
            }
            var _loc_7:* = new Array();
            if (_loc_6 != null)
            {
                _loc_5 = 0;
                while (_loc_5 < _loc_6.length)
                {
                    
                    _loc_7.push(_loc_6[_loc_5].item);
                    _loc_5 = _loc_5 + 1;
                }
            }
            _loc_7.push(this.VerMenu);
			_loc_7.push(this.CopyRight);
            this._contextMenu.hideBuiltInItems();
            this._contextMenu.customItems = _loc_7;
            return;
        }// end function

        public function addVideoMenu(param1:int, param2:String, param3:String, param4:int = 0) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            return this.vod[param1].addMenu(param2, param3, param4);
        }// end function

        public function delVideoMenu(param1:int, param2:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            return this.vod[param1].delMenu(param2);
        }// end function

        public function clearVideoMenu(param1:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            return this.vod[param1].clearMenu();
        }// end function

        public function stopListen()
        {
            RtmpManager.stopListen();
            ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "stopListen");
            return;
        }// end function

        public function startVod(param1:int, param2:String, param3:String, param4:String, param5:String, param6:Boolean, param7:String = "", param8:String = "") : int
        {
            var index:* = param1;
            var session:* = param2;
            var devIdno:* = param3;
            var channel:* = param4;
            var streamtype:* = param5;
            var playNow:* = param6;
            var server:* = param7;
            var port:* = param8;
            var sip:* = this.serverIP;
            var sport:* = this.serverPort;
            if (server != "")
            {
                sip = server;
            }
            if (port != "")
            {
                sport = port;
            }
            if (index < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (index >= this.num)
            {
                return 2;
            }
            if (sip == "" || sport == "")
            {
                return 4;
            }
            var urlParm:* = new UrlParm();
            urlParm.Channel = channel;
            urlParm.DevIdno = devIdno;
            urlParm.ServerIp = sip;
            urlParm.ServerPort = sport;
            urlParm.Session = session;
            urlParm.StreamType = streamtype;
            urlParm.AvType = 1;
            urlParm.MediaType = 1;
            if (this.vod[index] == null)
            {
                this.vod[index] = new player();
                addChildAt(this.vod[index], 0);
                this.vod[index].id = index;
                this.vod[index].addEventListener(playerEvent.CLICK, this.selectVod);
                this.vod[index].addEventListener(playerEvent.DOUBLE_CLICK, this.vodFull);
                this.vod[index].addEventListener(playerEvent.ALLTIME, this.getAlltime);
                this.vod[index].addEventListener(playEvent.SOUND, this.onSound);
                this.vod[index].setRect(this.rect[index]);
            }
            this.vod[index].urlParm = urlParm;
            if (this.num == 1)
            {
                this.currVod = this.vod[index];
//                this.tool.setVod(this.currVod);
            }
//            this.vod[index].disvol();
            this.vod[index].iswait = false;
            this.vod[index].showLoading();
			var url = "http://"+server+":"+port+"/realstream?fmt=flv&vchn="+channel+"&vstreamtype="+streamtype+"&achn=-1&atype=0&datatype=0&phone="+devIdno;
			vod[index].flvstat = 1;
			if (playNow)
			{
				vod[index].playFLV(url);
				if (num == 1)
				{
					currVod = vod[index];
				}
			}
            this.addEventListener(Event.ENTER_FRAME, this.refreshTime);
            return 0;
        }// end function
		
		public function resetTalk():int{
			RtmpManager.reStartTalk();
			return 0;
		}
		
        public function startVideo(param1:int, param2:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                this.vod[param1] = new player();
                addChildAt(this.vod[param1], 0);
                this.vod[param1].id = param1;
                this.vod[param1].addEventListener(playerEvent.CLICK, this.selectVod);
                this.vod[param1].addEventListener(playerEvent.DOUBLE_CLICK, this.vodFull);
                this.vod[param1].addEventListener(playerEvent.ALLTIME, this.getAlltime);
                this.vod[param1].addEventListener(playEvent.SOUND, this.onSound);
                this.vod[param1].addEventListener(playEvent.FULL, this.onFull);
                this.vod[param1].addEventListener(playEvent.NORM, this.onNorm);
                this.vod[param1].setRect(this.rect[param1]);
            }
            this.vod[param1].param = "";
            this.vod[param1].flvstat = 2;
            this.vod[param1].playFLV(param2);
//            this.vod[param1].disvol();
            if (this.num == 1)
            {
                this.vod[param1].ablevol();
                this.currVod = this.vod[param1];
//                this.tool.setVod(this.currVod);
            }
            this.addEventListener(Event.ENTER_FRAME, this.refreshTime);
            return 0;
        }// end function

        function vodPlay(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget.id;
            this.vod[_loc_2].Play();
//            this.tool.setPlayBtn();
            event.currentTarget.visible = false;
            return;
        }// end function

        public function setWindowNum(param1:int) : int
        {
            if (param1 <= 0)
            {
                return 1;
            }
            this.num = param1;
            this.free();
            RectManager.stage = stage;
            RectManager.setRectNum(param1);
            var _loc_2:* = 0;
            while (_loc_2 < this.num)
            {
                
                this.rect[_loc_2] = RectManager.Rect[_loc_2];
                if (this.vod[_loc_2] == null)
                {
                    this.vod[_loc_2] = new player();
                    this.vod[_loc_2].updatePic(this.cfg);
                    addChildAt(this.vod[_loc_2], 0);
                    this.vod[_loc_2].addEventListener(playerEvent.CLICK, this.selectVod);
                    this.vod[_loc_2].addEventListener(playerEvent.DOUBLE_CLICK, this.vodFull);
                    this.vod[_loc_2].addEventListener(playerEvent.ALLTIME, this.getAlltime);
                    this.vod[_loc_2].addEventListener(playEvent.SOUND, this.onSound);
                    this.vod[_loc_2].addEventListener(playEvent.FULL, this.onFull);
                    this.vod[_loc_2].addEventListener(playEvent.NORM, this.onNorm);
                }
                this.vod[_loc_2].setRect(this.rect[_loc_2]);
                this.vod[_loc_2].setNorm();
                this.vod[_loc_2].id = _loc_2;
//                this.vod[_loc_2].disvol();
                this.vod[_loc_2].visible = true;
                this.vod[_loc_2].hideBorder();
                _loc_2 = _loc_2 + 1;
            }
            if (this.num == 1)
            {
                this.vod[0].hideBorder();
            }
            else if (this.num > 1 && (this.currVod == null || this.currVod.id > (this.num - 1)))
            {
                this.selectVideo(0);
            }
            else
            {
                this.currVod.showBorder();
            }
            return 0;
        }// end function

        public function stopVideo(param1:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.vod.length)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].Stop();
            return 0;
        }// end function

        public function pauseVideo(param1:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.vod[param1].Paus();
//            if (this.currVod.id == param1)
//            {
//                this.tool.setVod(this.currVod);
//            }
            return 0;
        }// end function

        function resizeVod() : void
        {
            var _loc_2:* = undefined;
            if (stage.displayState != StageDisplayState.FULL_SCREEN)
            {
//                this.tool.setNorm();
                _loc_2 = 0;
                while (_loc_2 < this.vod.length)
                {
                    
                    if (this.vod[_loc_2] != null)
                    {
                        this.vod[_loc_2].CtrlPan.bf.onNorm();
                    }
                    _loc_2 = _loc_2 + 1;
                }
                ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "WindowNorm");
            }
            else
            {
                _loc_2 = 0;
                while (_loc_2 < this.vod.length)
                {
                    
                    if (this.vod[_loc_2] != null)
                    {
                        this.vod[_loc_2].CtrlPan.bf.onFull();
                    }
                    _loc_2 = _loc_2 + 1;
                }
                ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "WindowFull");
            }
            RectManager.stage = stage;
            RectManager.reSizeVideo();
            var _loc_1:* = 0;
            while (_loc_1 < this.num)
            {
                
                if (this.vod[_loc_1] != null)
                {
                    this.vod[_loc_1].reSize();
                }
                _loc_1 = _loc_1 + 1;
            }
            if (this.currVod != null)
            {
                this.currVod.showBorder();
            }
            return;
        }// end function

        function refreshTime(event:Event) : void
        {
            if (this.currVod == null)
            {
                return;
            }
//            this.tool.setTime(this.currVod.getPos());
            return;
        }// end function

        function getAlltime(event:playerEvent) : void
        {
            if (this.currVod == event.target)
            {
//                this.tool.setVod(this.currVod);
            }
            return;
        }// end function

        function vodFull(event:playerEvent) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            if (this.num <= 1)
            {
                return;
            }
            if (this.vod[event.currentTarget.id].isfull)
            {
                _loc_2 = 0;
                while (_loc_2 < this.num)
                {
                    
                    if (this.vod[_loc_2] != null)
                    {
                        this.vod[_loc_2].visible = true;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                this.vod[event.currentTarget.id].isfull = false;
                this.vod[event.currentTarget.id].reSize();
                this.vod[event.currentTarget.id].showBorder();
                ExternalInterface.call("onTtxVideoMsg", "" + event.currentTarget.id + "", "norm");
            }
            else
            {
                if (this.currVod != null)
                {
                    this.currVod.hideBorder();
                }
                _loc_3 = 0;
                while (_loc_3 < this.num)
                {
                    
                    if (event.currentTarget.id != _loc_3)
                    {
                        if (this.vod[_loc_3] != null)
                        {
                            this.vod[_loc_3].visible = false;
                        }
                    }
                    else
                    {
                        this.vod[_loc_3].setFull();
                    }
                    _loc_3 = _loc_3 + 1;
                }
                ExternalInterface.call("onTtxVideoMsg", "" + event.currentTarget.id + "", "full");
            }
            this.currVod = this.vod[event.currentTarget.id];
//            this.tool.setVod(this.currVod);
            return;
        }// end function

        function onFull(event:playEvent) : void
        {
            ExternalInterface.call("onTtxVideoMsg", "" + event.currentTarget.id + "", "WindowFull");
            stage.displayState = StageDisplayState.FULL_SCREEN;
            var _loc_2:* = 0;
            while (_loc_2 < this.vod.length)
            {
                
                if (this.vod[_loc_2] != null)
                {
                    this.vod[_loc_2].CtrlPan.bf.onFull();
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function onNorm(event:playEvent) : void
        {
            ExternalInterface.call("onTtxVideoMsg", "" + event.currentTarget.id + "", "WindowNorm");
            stage.displayState = StageDisplayState.NORMAL;
            var _loc_2:* = 0;
            while (_loc_2 < this.vod.length)
            {
                
                if (this.vod[_loc_2] != null)
                {
                    this.vod[_loc_2].CtrlPan.bf.onNorm();
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function onSound(event:playEvent) : void
        {
//            this.disAllSound();
//            event.currentTarget.ablevol();
//            this.stopListen();
//            this.stopTalkback();
            return;
        }// end function

        function selectVideo(param1:int) : void
        {
            if (this.currVod != null)
            {
                this.currVod.hideBorder();
            }
            this.currVod = this.vod[param1];
            this.currVod.showBorder();
            if (this.currVod.isPlaying)
            {
                this.disAllSound();
//                this.currVod.ablevol();
            }
//            this.tool.setVod(this.currVod);
            ExternalInterface.call("onTtxVideoMsg", "" + param1 + "", "select");
            return;
        }// end function

        function selectVod(event:playerEvent) : void
        {
            if (this.num <= 1)
            {
                return;
            }
            this.selectVideo(event.currentTarget.id);
            return;
        }// end function

        function disAllSound():void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.vod.length)
            {
                
                if (this.vod[_loc_1] != null)
                {
//                    this.vod[_loc_1].disvol();
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        function free() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.num)
            {
                
                if (this.vod[_loc_1] != null)
                {
                    this.vod[_loc_1].visible = true;
                }
                _loc_1 = _loc_1 + 1;
            }
            var _loc_2:* = this.num;
            while (_loc_2 < this.vod.length)
            {
                
                if (this.vod[_loc_2] != null)
                {
                    this.vod[_loc_2].visible = false;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function setPIC(event:configEvent) : void
        {
           	if(this.vod.length == 0){
				setWindowNum(4);
				return;
			}
			var _loc_2:* = 0;
            while (_loc_2 < this.num)
            {
                
                if (this.vod[_loc_2] != null)
                {
                    this.vod[_loc_2].updatePic(this.cfg);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        function setVideoInfo(param1:int, param2:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            if (this.vod[param1] != null)
            {
                this.vod[param1].setVideoInfo(param2);
            }
            return 0;
        }// end function

        function updateUiText(event:langEvent) : void
        {
//            this.tool.updateUiText(this.lang);
            var _loc_2:* = 0;
            while (_loc_2 < this.num)
            {
                
                if (this.vod[_loc_2] != null)
                {
                    this.vod[_loc_2].updateUiText(this.lang);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function setVideoFrame(param1:int, param2:String) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.vod.length)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            if (this.vod[param1] != null)
            {
                this.vod[param1].WH = param2;
                this.vod[param1].reSize();
                return 0;
            }
            return 0;
        }// end function

        public function setBufferTime(param1:int, param2:Number) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            if (param2 <= 0)
            {
                return 5;
            }
            if (this.vod[param1] != null)
            {
                this.vod[param1].setBufferTime(param2);
            }
            return 0;
        }// end function

        public function reSetVideo(param1:int)
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.vod.length)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            if (this.vod[param1] != null)
            {
                this.vod[param1].reSet();
            }
            return 0;
        }// end function

        public function setVideoFocus(param1:int) : int
        {
            if (param1 < 0)
            {
                return 3;
            }
            if (this.num == 0)
            {
                return 1;
            }
            if (param1 >= this.num)
            {
                return 2;
            }
            if (this.vod[param1] == null)
            {
                return 4;
            }
            this.selectVideo(param1);
            return 0;
        }// end function

    }
}
