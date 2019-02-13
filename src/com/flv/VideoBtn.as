package com.flv
{
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    

    public class VideoBtn extends Sprite
    {
        public var btnPlay:MovieClip;
        var Rect:RECT;
        var isFull:Boolean = false;
		
		[Embed(source="../images/sprite70.swf")]  
		[Bindable]    
		private var normal:Class;
		
		var img:Bitmap = new Bitmap();
        public function VideoBtn()
        {
			btnPlay = new normal();
//			addChild(btnPlay);
			this.btnPlay.addEventListener(MouseEvent.CLICK, this.onPlay);
            this.visible = false;
            return;
        }// end function

        function onPlay(event:Event) : void
        {
            var _loc_2:* = new playEvent("play");
            dispatchEvent(_loc_2);
            this.visible = false;
            event.stopPropagation();
            return;
        }// end function

        public function reSize() : void
        {
            if (this.isFull)
            {
                this.btnPlay.x = this.Rect.sw/2-50;
                this.btnPlay.y = this.Rect.sh/2-50;
            }
            else
            {
                this.btnPlay.x = this.Rect.rx + this.Rect.rw / 2;
                this.btnPlay.y = this.Rect.ry + this.Rect.rh / 2;
            }
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.Rect = param1;
            this.reSize();
            return;
        }// end function

    }
}
