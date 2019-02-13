package com.flv
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class tools extends MovieClip
    {
        public var pausbtn:smpaus = new smpaus();
        public var nmbtn:norbtn = new norbtn();
        public var fullbtn:fullbtn1 = new fullbtn1();
        public var l1:MovieClip= new MovieClip();
        public var toolsBG:MovieClip = new MovieClip();
        public var l2:MovieClip= new MovieClip();
//        public var timBar:timeBar = new timeBar();
        public var l3:MovieClip= new MovieClip();
        public var stopbtn:smstop = new smstop();
        public var playbtn:smplay = new smplay();
        public var vod:player;

        public function tools() : void
        {
            this.pausbtn.visible = false;
            this.nmbtn.visible = false;
//            this.timBar.addEventListener(timeEvent.TIME, this.tim);
            this.playbtn.addEventListener(MouseEvent.CLICK, this.fplay);
            this.pausbtn.addEventListener(MouseEvent.CLICK, this.fpaus);
            this.stopbtn.addEventListener(MouseEvent.CLICK, this.fstop);
            this.fullbtn.addEventListener(MouseEvent.CLICK, this.ffull);
            this.nmbtn.addEventListener(MouseEvent.CLICK, this.fnorm);
            this.playbtn.disable();
            this.stopbtn.disable();
            this.pausbtn.disable();
            return;
        }// end function

        public function setVod(param1:player) : void
        {
            this.vod = param1;
//            this.timBar.setAlltime(param1._duration);
            if (param1 == null || param1.iswait && param1.flvurl == "")
            {
                this.playbtn.disable();
                this.stopbtn.disable();
                this.pausbtn.disable();
            }
            else
            {
                this.playbtn.enable();
                this.pausbtn.enable();
                if (param1.iswait)
                {
                    this.stopbtn.disable();
                }
                else
                {
                    this.stopbtn.enable();
                }
                if (param1.ispaus)
                {
                    this.pausbtn.visible = false;
                    this.playbtn.visible = true;
                }
                else
                {
                    this.pausbtn.visible = true;
                    this.playbtn.visible = false;
                }
            }
            return;
        }// end function


        function ffull(event:MouseEvent) : void
        {
            this.fullbtn.visible = false;
            this.nmbtn.visible = true;
            dispatchEvent(new playEvent("full"));
            return;
        }// end function

        public function setNorm() : void
        {
            this.fullbtn.visible = true;
            this.nmbtn.visible = false;
            return;
        }// end function

        function fnorm(event:MouseEvent) : void
        {
            this.fullbtn.visible = true;
            this.nmbtn.visible = false;
            dispatchEvent(new playEvent("norm"));
            return;
        }// end function

        function fplay(event:MouseEvent) : void
        {
            if (this.vod == null || this.vod.iswait && this.vod.flvstat == 0)
            {
                return;
            }
            this.playbtn.visible = false;
            this.pausbtn.visible = true;
            dispatchEvent(new playEvent("play"));
            return;
        }// end function

        function fstop(event:MouseEvent) : void
        {
            if (this.vod == null || this.vod.iswait)
            {
                return;
            }
            dispatchEvent(new playEvent("stop"));
            return;
        }// end function

        function fpaus(event:MouseEvent) : void
        {
            if (this.vod == null || this.vod.iswait)
            {
                return;
            }
            this.playbtn.visible = true;
            this.pausbtn.visible = false;
            dispatchEvent(new playEvent("paus"));
            return;
        }// end function

        public function setPlayBtn() : void
        {
            this.playbtn.visible = false;
            this.pausbtn.visible = true;
            return;
        }// end function


        public function setTime(param1:Number) : void
        {
//            this.timBar.setTime(param1);
            return;
        }// end function

        public function changeSize() : void
        {
            var _loc_1:* = stage.stageWidth;
            var _loc_2:* = 200 - this.height + stage.stageHeight / 2;
            this.y = _loc_2;
//            this.timBar.changeSize();
            this.toolsBG.width = stage.stageWidth + 5;
            this.toolsBG.x = 275 - stage.stageWidth / 2;
            this.playbtn.x = 15 + 275 - stage.stageWidth / 2;
            this.pausbtn.x = 15 + 275 - stage.stageWidth / 2;
            this.stopbtn.x = this.playbtn.x + 30;
            this.l1.x = this.stopbtn.x + 30;
            this.fullbtn.x = 550 + _loc_1 / 2 - 265 - 40;
            this.nmbtn.x = 550 + _loc_1 / 2 - 265 - 40;
            this.l3.x = this.fullbtn.x - 16;
            return;
        }// end function

        public function updateUiText(param1:language) : void
        {
            this.playbtn.setLable(param1.playTxt);
            this.pausbtn.setLable(param1.pausTxt);
            this.fullbtn.setLable(param1.full);
            this.stopbtn.setLable(param1.stopTxt);
            this.nmbtn.setLable(param1.norm);
//            this.timBar.fpre.setLable(param1.fastPre);
//            this.timBar.fnxt.setLable(param1.fastNxt);
            return;
        }// end function

    }
}
