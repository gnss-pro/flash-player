package com.flv
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class logo extends Sprite
    {
        public var logoTxt:TextField = new TextField;
        public var px:Number = 0;
        public var py:Number = 0;
        var ld:Loader;
        public var Rect:RECT;
        public var isFull:Object = false;

        public function logo() : void
        {
            this.logoTxt.visible = false;
            return;
        }// end function

        public function reSet()
        {
            this.logoTxt.visible = false;
            this.logoTxt.textColor = 0;
            this.logoTxt.text = "";
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.Rect = param1;
            return;
        }// end function

        public function reSize() : void
        {
            if (this.isFull)
            {
                this.x = 1;
                this.y = 1
            }
            else
            {
                this.x = this.Rect.rx;
                this.y = this.Rect.ry;
            }
            return;
        }// end function

        function oncmp(event:Event) : void
        {
            addChild(this.ld);
            this.reSize();
            return;
        }// end function

        public function updatePic(param1:config) : void
        {
            if (param1.logo == "")
            {
                return;
            }
            if (this.ld != null)
            {
                removeChild(this.ld);
                this.ld = null;
            }
            this.ld = new Loader();
            this.ld.contentLoaderInfo.addEventListener(Event.COMPLETE, this.oncmp);
            var _loc_2:* = new URLRequest(param1.logo);
            this.ld.load(_loc_2);
            return;
        }// end function

        function setTxt(param1:String, param2:Number, param3:int, param4:int, param5:int) : void
        {
            this.logoTxt.visible = true;
            this.logoTxt.textColor = param2;
            this.logoTxt.text = param1;
            var _loc_6:* = new TextFormat();
            _loc_6.size = param5;
            this.logoTxt.setTextFormat(_loc_6);
            this.logoTxt.x = param3;
            this.logoTxt.y = param4;
            this.reSize();
            return;
        }// end function

        public function setLogo(param1:String, param2:int, param3:int) : void
        {
            if (this.ld != null)
            {
                removeChild(this.ld);
                this.ld = null;
            }
            this.ld = new Loader();
            this.ld.contentLoaderInfo.addEventListener(Event.COMPLETE, this.oncmp);
            var _loc_4:* = new URLRequest(param1);
            this.ld.load(_loc_4);
            this.ld.x = param2;
            this.ld.y = param3;
            return;
        }// end function

    }
}
