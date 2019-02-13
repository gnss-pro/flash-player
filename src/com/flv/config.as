package com.flv
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import mx.core.BitmapAsset;

    public class config extends EventDispatcher
    {
        var ld:URLLoader;
        var rqst:URLRequest;
        var playerBG:String;
        var bg:Object;
		var logo:String;
		
		[Embed(source="../images/player.jpg")]
		[Bindable]
		public var playerbg:Class;
        public function config() : void
        {
            this.playerBG = "";
			this.logo="";
            this.bg = new playerbg();
            this.ld = new URLLoader();
//			this.bg.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onloadBG);
            this.ld.addEventListener(Event.COMPLETE, this.oncmp);
            ExternalInterface.addCallback("setConfig", this.setConfig);
        }// end function

        public function setConfig(param1:String) : void
        {
            var _loc_2:* = new URLRequest(param1);
            this.ld.load(_loc_2);
            return;
        }// end function

        function oncmp(event:Event) : void
        {
			var _loc_2:* = JSON(this.ld.data);
            this.playerBG = _loc_2.attribute("playerBG");
            if (this.bg != null)
            {
                this.bg = null;
            }
            this.bg = new Loader();
			this.bg.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onloadBG);
            var _loc_3:* = new URLRequest(this.playerBG);
			this.bg.load(_loc_3);
            return;
        }// end function

        function onloadBG(event:Event) : void
        {
            trace("getBg");
            dispatchEvent(new configEvent());
            return;
        }// end function

        public function getBG() : Sprite
        {
            var _loc_1:* = new Sprite();
            //var _loc_2:BitmapData = new BitmapData(this.bg.content.width, this.bg.content.height, true, 0);
            //_loc_2.draw(BitmapAsset(this.bg));
            _loc_1.addChild(new Bitmap(BitmapAsset(this.bg).bitmapData));
            return _loc_1;
        }// end function

    }
}
