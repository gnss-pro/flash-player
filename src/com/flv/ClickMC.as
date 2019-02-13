package com.flv
{
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class ClickMC extends Sprite
    {
        public var mc:MovieClip = new MovieClip();
        var Rect:RECT;
        public var isFull:Boolean = true;
		
		[Embed(source="../images/sprite76.swf")]  
		[Bindable]    
		private var bg:Class;
        public function ClickMC()
        {
           	mc = new bg();
			addChild(mc);
			return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.mouseChildren = false;
            this.doubleClickEnabled = true;
            this.Rect = param1;
            return;
        }// end function

        public function reSize() : void
        {
            if (this.isFull)
            {
                this.mc.x = 1;
                this.mc.y = 1;
                this.mc.height = this.Rect.sh;
                this.mc.width = this.Rect.sw;
            }
            else
            {
                this.mc.x = this.Rect.rx;
                this.mc.y = this.Rect.ry-11;
                this.mc.height = this.Rect.rh;
                this.mc.width = this.Rect.rw;
            }
            return;
        }// end function

        public function Show()
        {
            trace("show mask");
            this.mc.alpha = 0.7;
            return;
        }// end function

        public function Hide()
        {
            this.mc.alpha = 0;
            return;
        }// end function

    }
}
