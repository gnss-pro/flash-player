package com.flv
{
    import flash.display.Sprite;

    public class VideoInfoBg extends Sprite
    {
        var color:Object  = 0;
        var alp:int  = 1;

        public function VideoInfoBg()
        {
            this.graphics.beginFill(Number(this.color), this.alp);
            this.graphics.drawRect(0, 1, 200, 30);
            this.graphics.endFill();
            return;
        }// end function

        public function setColor(param1:String, param2:Number = 1) : void
        {
            this.color = "0x" + param1;
			this.alp = param2;
            this.graphics.clear();
            this.graphics.beginFill(Number(this.color), param2);
            this.graphics.drawRect(0, 1, 200, 30);
            this.graphics.endFill();
            return;
        }// end function

    }
}
