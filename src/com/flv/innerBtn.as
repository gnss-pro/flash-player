package com.flv
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class innerBtn extends MovieClip
    {
        private var able:Boolean = false;

        public function innerBtn()
        {
            this.switchFrame(3);
            return;
        }// end function

        function mson(event:Event) : void
        {
            if (this.able == false)
            {
                return;
            }
            this.switchFrame(2);
            return;
        }// end function

        function msout(event:Event) : void
        {
            this.switchFrame(1);
            return;
        }// end function

        public function disable() : void
        {
            this.removeEventListener(MouseEvent.MOUSE_OVER, this.mson);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this.msout);
            this.able = false;
            this.switchFrame(3);
            return;
        }// end function

        public function enable() : void
        {
            this.able = true;
            this.switchFrame(1);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.mson);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.msout);
            return;
        }// end function
		
		public function switchFrame(index:int):void{
			
		}
    }
}
