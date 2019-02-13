package com.flv
{
    import flash.events.*;

    public class langEvent extends Event
    {
        public static const CHANGE:String = "change";

        public function langEvent() : void
        {
            super(CHANGE);
            return;
        }// end function

    }
}
