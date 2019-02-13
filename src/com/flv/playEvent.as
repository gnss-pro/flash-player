package com.flv
{
    import flash.events.*;

    public class playEvent extends Event
    {
        public var ev:String;
        public static const FULL:String = "full";
        public static const NORM:String = "norm";
        public static const PLAY:String = "play";
        public static const STOP:String = "stop";
        public static const PAUS:String = "paus";
        public static const SOUND:String = "sound";
        public static const SILENT:String = "silent";
        public static const CAPTURE:String = "capture";

        public function playEvent(param1:String) : void
        {
            this.ev = param1;
            super(param1);
            return;
        }// end function

    }
}
