package com.flv
{
    import com.flv.RECT;
    
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class loading extends MovieClip
    {
        public var ldinfo:TextField = new TextField();
        public var loadingTxt:TextField = new TextField();
        var rect:RECT;
        var isfull:Boolean;
        public function loading()
        {
            this.isfull = false;
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.rect = param1;
            return;
        }// end function

        public function reSize() : void
        {
            if (this.isfull)
            {
                this.x = 275 - this.width / 2;
                this.y = 200 - this.height / 2;
            }
            else
            {
                this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
                this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
            }
            return;
        }// end function

    }
}
