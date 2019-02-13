package com.flv
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class myButton extends MovieClip
    {
        public var lable:TextField = new TextField();

        public function myButton() : void
        {
            this.buttonMode = true;
            this.mouseChildren = false;
            stop();
            this.lable.visible = false;
            addEventListener(MouseEvent.MOUSE_OVER, this.msover);
            addEventListener(MouseEvent.MOUSE_OUT, this.msout);
            return;
        }// end function

        public function disable() : void
        {
            gotoAndStop(3);
            return;
        }// end function

        public function enable() : void
        {
            gotoAndStop(1);
            this.lable.visible = false;
            return;
        }// end function

        function msover(event:MouseEvent) : void
        {
            if (currentFrame == 3)
            {
                return;
            }
            gotoAndStop(2);
            this.lable.visible = true;
            return;
        }// end function

        function msout(event:MouseEvent) : void
        {
            if (currentFrame == 3)
            {
                return;
            }
            gotoAndStop(1);
            this.lable.visible = false;
            return;
        }// end function

        function setLable(param1:String) : void
        {
            this.lable.text = param1;
            return;
        }// end function

    }
}
