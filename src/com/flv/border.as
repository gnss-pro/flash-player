package com.flv
{
	import flash.display.DisplayObject;
    import com.flv.RECT;
    import com.flv.config;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;

    public class border extends MovieClip
    {
        var color:uint = 65280;
        var rect:RECT;
        var ld:DisplayObject;
        public var stat:int = 0;
        public static const norm:int = 0;
        public static const sel:int = 1;
        public static const full:int = 2;
        public static const wait:int = 3;
        public static const waitsel:int = 4;
        public static const waitfull:int = 5;
        public static const began:int = 6;
        public static const beganfull:int = 7;
        public static const colArr:Array = [0, 65280, 255, 255, 255];

        public function border() : void
        {
            this.stat = 3;
			this.color=0xff0000;
            return;
        }// end function

        public function reSize()
        {
            this.updateBG();
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.rect = param1;
            this.updateBG();
            return;
        }// end function

        public function updateBG1() : void
        {
            graphics.clear();
            switch(this.stat)
            {
                case norm:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 4, this.rect.rh + 4);
                    break;
                }
                case sel:
                {
                    graphics.beginFill(colArr[1]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 4, this.rect.rh + 4);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(this.rect.rx, this.rect.ry, this.rect.rw, this.rect.rh);
                    break;
                }
                case full:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
                    break;
                }
                case wait:
                {
                    graphics.beginFill(colArr[3]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 4, this.rect.rh + 4);
                    break;
                }
                case waitsel:
                {
                    graphics.beginFill(colArr[1]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 4, this.rect.rh + 4);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(this.rect.rx, this.rect.ry, this.rect.rw, this.rect.rh);
                    break;
                }
                case waitfull:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
                    break;
                }
                default:
                {
                    break;
                }
            }
            graphics.endFill();
            return;
        }// end function

        public function updateBG2() : void
        {
            graphics.clear();
            this.ld.visible = true;
            this.ld.width = Object(this.parent).video.width;
            this.ld.height = Object(this.parent).video.height;
            this.ld.x = Object(this.parent).video.x;
            this.ld.y = Object(this.parent).video.y;
            switch(this.stat)
            {
                case norm:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
                    break;
                }
                case sel:
                {
                    graphics.beginFill(colArr[1]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(this.rect.rx, this.rect.ry, this.rect.rw, this.rect.rh);
                    break;
                }
                case full:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
                    trace(2);
                    break;
                }
                case wait:
                {
                    graphics.beginFill(colArr[3]);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
                    break;
                }
                case waitsel:
                {
                    graphics.beginFill(colArr[1]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(this.rect.rx, this.rect.ry, this.rect.rw, this.rect.rh);
                    break;
                }
                case began:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
                    this.ld.visible = false;
                    break;
                }
                case waitfull:
                case beganfull:
                {
                    graphics.beginFill(colArr[0]);
                    graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
                    this.ld.visible = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
            graphics.endFill();
            return;
        }// end function

        public function updateBG() : void
        {
            if (this.ld != null)
            {
                this.updateBG2();
            }
            else
            {
                this.updateBG1();
            }
            var _loc_1:* = Object(this.parent).iswait;
            this.ld.visible = _loc_1;
            return;
        }// end function

        public function showBorder() : void
        {
            graphics.clear();
            graphics.beginFill(this.color);
            graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 4, this.rect.rh + 4);
            graphics.endFill();
            return;
        }// end function

        public function showBorderFull() : void
        {
            graphics.beginFill(this.color);
            graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
            graphics.endFill();
            return;
        }// end function

        public function rsSize() : void
        {
            this.updateBG();
            return;
        }// end function

        function oncmp(event:Event) : void
        {
            addChild(this.ld);
            this.updateBG();
            return;
        }// end function

        public function updatePic(param1:config) : void
        {
            if (this.ld != null)
            {
                removeChild(this.ld);
                this.ld = null;
            }
            this.ld = param1.getBG();
            addChildAt(this.ld, 0);
            if (this.rect != null)
            {
                this.updateBG();
            }
            return;
        }// end function

        public function hideBorder2() : void
        {
            graphics.clear();
            graphics.beginFill(255);
            graphics.drawRect(275 - this.rect.sw / 2, 200 - this.rect.sh / 2, this.rect.sw, this.rect.sh);
            graphics.endFill();
            trace(String(275 - this.rect.sw / 2) + "  " + String(200 - this.rect.sh / 2) + " " + String(this.rect.sw) + " " + String(this.rect.sh));
            return;
        }// end function

        public function hideBorder() : void
        {
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect((this.rect.rx - 1), (this.rect.ry - 1), this.rect.rw + 2, this.rect.rh + 2);
            graphics.endFill();
            return;
        }// end function

    }
}
