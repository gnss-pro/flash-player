package com.flv
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.Label;
    import mx.controls.ToolTip;

    public class btnSound extends MovieClip
    {
        public var innerBtn2:innerBtnSdOff;
        public var innerBtn1:innerBtnSdon;
        public var tip:myButton = new myButton();
        var eb:Object = false;

        public function btnSound() : void
        {
            stop();
            this.tip.visible = false;
            this.updateUiText();
            return;
        }// end function

        public function enable()
        {
            this.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.msover);
            addEventListener(MouseEvent.MOUSE_OUT, this.msout);
            addEventListener(MouseEvent.CLICK, this.onsound);
            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
            _loc_1.enable();
            this.eb = true;
            return;
        }// end function

        public function disable()
        {
            this.buttonMode = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.msover);
            removeEventListener(MouseEvent.MOUSE_OUT, this.msout);
            removeEventListener(MouseEvent.CLICK, this.onsound);
            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
            _loc_1.disable();
            this.eb = false;
            return;
        }// end function

        function onsound(event:Event) : void
        {
            var _loc_2:* = undefined;
            if (currentFrame == 1)
            {
                gotoAndStop(2);
                this.tip.lable.text = Common.lang.enableSound;
                _loc_2 = new playEvent("silent");
            }
            else
            {
                gotoAndStop(1);
                this.tip.lable.text = Common.lang.disableSound;
                _loc_2 = new playEvent("sound");
            }
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
            if (currentFrame == 2)
            {
                this.tip.lable.text = Common.lang.enableSound;
            }
            else
            {
                this.tip.lable.text = Common.lang.disableSound;
            }
            return;
        }// end function

        public function silent()
        {
            var _loc_1:* = undefined;
            gotoAndStop(2);
            if (this.eb)
            {
                _loc_1 = this.getChildByName("innerBtn" + currentFrame);
                _loc_1.enable();
            }
            this.tip.lable.text = Common.lang.enableSound;
            return;
        }// end function

        public function sound()
        {
            var _loc_1:* = undefined;
            gotoAndStop(1);
            if (this.eb)
            {
                _loc_1 = this.getChildByName("innerBtn" + currentFrame);
                _loc_1.enable();
            }
            this.tip.lable.text = Common.lang.disableSound;
            return;
        }// end function

    }
}
