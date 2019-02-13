package com.flv
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextFormat;

    public class VideoCtrl extends Sprite
    {
        public var bc:btnCap = new btnCap();
        public var InfoBar:infoBar = new infoBar();
        public var bf:btnFull = new btnFull();
        public var bp:btnPlay = new btnPlay();
        public var info:String = "";
        public var Rect:RECT;
        public var isFull:Boolean = false;
		
		
        public function VideoCtrl()
        {
            this.info = "";
			addChild(InfoBar);
			addChild(bc);
			addChild(bp);
			addChild(bf);
			
            this.bp.addEventListener(playEvent.PLAY, this.dispatch);
            this.bp.addEventListener(playEvent.PAUS, this.dispatch);
            this.bp.addEventListener(playEvent.STOP, this.dispatch);
            this.bf.addEventListener(playEvent.FULL, this.dispatch);
            this.bf.addEventListener(playEvent.NORM, this.dispatch);
            this.bc.addEventListener(playEvent.CAPTURE, this.dispatch);
            return;
        }// end function

        public function reSet()
        {
            this.info = "";
            this.InfoBar.BackGround.setColor("000000");
            return;
        }// end function

        function dispatch(event:playEvent) : void
        {
            var _loc_2:* = new playEvent(event.ev);
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function setBps(param1:Number) : void
        {
            param1 = int(param1);
            var _loc_2:* = this.info + " " + param1 + "KB/S";
            this.InfoBar.infoTxt.text = _loc_2;
			var format:TextFormat=new TextFormat();
			format.color = 0xffffff;
			this.InfoBar.infoTxt.setTextFormat(format);
            return;
        }// end function

        public function setColor(param1:String) : void
        {
            this.InfoBar.BackGround.setColor(param1);
            return;
        }// end function

        public function showInfo() : void
        {
            this.InfoBar.infoTxt.text = this.info;
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.Rect = param1;
            this.reSize();
            return;
        }// end function

        public function reSize() : void
        {
			this.graphics.drawRect(Rect.rx,Rect.ry,Rect.rw,30);
//			addChild(InfoBar);
//			addChild(bc);
//			addChild(bp);
//			addChild(bf);
			if (this.isFull)
            {
                this.InfoBar.BackGround.width = this.Rect.sw;
                this.y = this.Rect.sh - 30;
                this.x = 1;
                this.bf.x = this.Rect.sw - 30;
                this.bp.x = this.bf.x - 30;
                this.bc.x = this.bp.x - 30;
            }
            else
            {
                this.InfoBar.BackGround.width = this.Rect.rw;
                this.y = this.Rect.ry + this.Rect.rh - 30;
                this.x = this.Rect.rx;
                this.bf.x = this.Rect.rw - 30;
                this.bp.x = this.bf.x - 30;
                this.bc.x = this.bp.x - 30;
            }
            this.InfoBar.infoTxt.width = this.InfoBar.BackGround.width - 100;
            if (this.InfoBar.infoTxt.width < 60)
            {
                this.InfoBar.infoTxt.visible = false;
            }
            else
            {
                this.InfoBar.infoTxt.visible = true;
            }
            return;
        }// end function

        function updateUiText()
        {
            this.bf.updateUiText();
            this.bp.updateUiText();
            this.bc.updateUiText();
            return;
        }// end function

        function enable()
        {
            this.bf.enable();
            this.bp.enable();
            this.bc.enable();
            return;
        }// end function

        function disable():void
        {
            this.InfoBar.infoTxt.text = "";
            this.bc.disable();
            this.bp.disable();
            return;
        }// end function

    }
}
