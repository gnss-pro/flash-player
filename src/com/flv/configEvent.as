package com.flv
{
    import flash.events.Event;

    public class configEvent extends Event
    {
        public static const CHANGE:String = "change";

        public function configEvent() : void
        {
            super(CHANGE);
            return;
        }// end function
		
    }
}
