package com.flv
{
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    
    import spark.components.Image;

    dynamic public class playerbg extends Loader
    {
		[Embed(source="../images/player.jpg")]
		[Bindable]
		public var bg:Class;
        public function playerbg()
        {
//			this.content = bg;
			this.load(new URLRequest("player.jpg"));
			return;
        }// end function

    }
}
