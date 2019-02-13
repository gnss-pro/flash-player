package com.flv
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class btnCap extends MovieClip
    {
        public var innerBtn1:innerBtnCap = new innerBtnCap();
        public var tip:Tip = new Tip();
        public function btnCap() : void
        {
			stop();
			addChild(innerBtn1);
            this.tip.visible = false;
            this.updateUiText();
            return;
        }// end function

        public function enable()
        {
			this.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.msover);
            addEventListener(MouseEvent.MOUSE_OUT, this.msout);
            addEventListener(MouseEvent.CLICK, this.onclick);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
			var _loc_1:* = this.getChildAt(currentFrame);
            _loc_1.enable();
            return;
        }// end function

        public function disable():void
        {
			this.buttonMode = false;
			removeEventListener(MouseEvent.MOUSE_OVER, this.msover);
            removeEventListener(MouseEvent.MOUSE_OUT, this.msout);
            removeEventListener(MouseEvent.CLICK, this.onclick);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
			var _loc_1:* = this.getChildAt(currentFrame);
            _loc_1.disable();
            return;
        }// end function

        function onclick(event:Event) : void
        {
			var _loc_2:* = new playEvent("capture");
            dispatchEvent(_loc_2);
            event.stopPropagation();
            return;
        }// end function

        function msover(event:MouseEvent) : void
        {
            this.tip.visible = true;
            return;
        }// end function

        function msout(event:MouseEvent) : void
        {
            this.tip.visible = false;
            return;
        }// end function

        function updateUiText() : void
        {
            this.tip.lable.text = Common.lang.capTxt;
            return;
        }// end function

    }
}
