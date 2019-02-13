package com.flv
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class btnFull extends MovieClip
    {
        public var innerBtn2:innerBtnNorm = new innerBtnNorm();
        public var innerBtn1:innerBtnFull = new innerBtnFull();
        public var tip:myButton = new myButton();
		public var index:int = 1;
        public function btnFull() : void
        {
            stop();
            this.tip.visible = false;
            this.updateUiText();
			this.onNorm();
            this.enable();
            return;
        }// end function

        public function enable()
        {
            this.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.msover);
            addEventListener(MouseEvent.MOUSE_OUT, this.msout);
            addEventListener(MouseEvent.CLICK, this.onclick);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
			var _loc_1:* = this.getChildAt(0);
            _loc_1.enable();
            return;
        }// end function

        public function disable():void
        {
            this.buttonMode = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.msover);
            removeEventListener(MouseEvent.MOUSE_OUT, this.msout);
            removeEventListener(MouseEvent.CLICK, this.onclick);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
			var _loc_1:* = this.getChildAt(0);
            _loc_1.disable();
            return;
        }// end function

        function onclick(event:Event) : void
        {
            var _loc_2:* = undefined;
            if (index == 1)
            {
                switchFrame(2);
                this.tip.lable.text = Common.lang.norm;
                _loc_2 = new playEvent("full");
            }
            else
            {
                switchFrame(1);
                this.tip.lable.text = Common.lang.full;
                _loc_2 = new playEvent("norm");
            }
            dispatchEvent(_loc_2);
            event.stopPropagation();
            return;
        }// end function

        function msover(event:MouseEvent) : void
        {
            this.tip.visible = true;
            return;
        }// end function

        function msout(event:MouseEvent) : void
        {
            this.tip.visible = false;
            return;
        }// end function

        function updateUiText() : void
        {
            if (index == 2)
            {
                this.tip.lable.text = Common.lang.norm;
            }
            else
            {
                this.tip.lable.text = Common.lang.full;
            }
            return;
        }// end function

        function onFull() : void
        {
            switchFrame(2);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
//			var _loc_1:* = this.getChildAt(currentFrame);
//            _loc_1.enable();
            this.updateUiText();
            return;
        }// end function

        function onNorm() : void
        {
            switchFrame(1);
//            var _loc_1:* = this.getChildByName("innerBtn" + currentFrame);
//			
//            _loc_1.enable();
            this.updateUiText();
            return;
        }// end function
		
		function switchFrame(index:int):void{
			this.index = index;
			try{
				this.removeChildAt(0);
			}catch(e:Error){
				
			}
			var btn:innerBtn;
			if(index == 1){
				btn = new innerBtnNorm();
			}else if(index == 2){
				btn = new innerBtnFull();
			}
			this.addChild(btn);
		}
    }
}
