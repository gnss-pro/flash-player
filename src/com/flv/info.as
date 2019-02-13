package com.flv
{
    import com.flv.Common;
    import com.flv.RECT;
    import com.flv.language;
    
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class info extends MovieClip
    {
        public var msgTxt:TextField = new TextField();
        var connectError:String = "";
        var offLine:String = "设备不在线";
        var connect:String = "正在连接";
        var waiting:String = "";
        var rect:RECT;
        var isfull:Boolean;
        var curr:String;

        public function info() : void
        {
            this.isfull = false;
            return;
        }// end function

        public function setRect(param1:RECT) : void
        {
            this.rect = param1;
            return;
        }// end function

        public function updateUiText(param1:language) : void
        {
            this.connectError = param1.connectError;
            this.offLine = param1.offLine;
            this.connect = param1.connect;
            this.waiting = param1.waiting;
            this.setMsg(this.curr);
            return;
        }// end function

        public function reSize() : void
        {
            if (this.isfull)
            {
//                this.x = 275 - this.width / 2;
//                this.y = 200 - this.height / 2;
				this.x = this.rect.sw/2;
				this.y = this.rect.sh/2;
            }
            else
            {
                this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
                this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
            }
            return;
        }// end function

        public function setMsg(param1:String) : void
        {
            if (this.isfull)
            {
                this.x = 275 - this.width / 2;
                this.y = 200 - this.height / 2;
            }
            else
            {
                this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
                this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
            }
            switch(param1)
            {
                case "connect":
                {
                    this.msgTxt.text = Common.lang.connect;
                    break;
                }
                case "offLine":
                {
                    this.msgTxt.text = Common.lang.offLine;
                    break;
                }
                case "connectError":
                {
                    this.msgTxt.text = Common.lang.connectError;
                    break;
                }
                case "waiting":
                {
                    this.msgTxt.text = "";
                    break;
                }
                default:
                {
                    this.msgTxt.text = "";
                    break;
                }
            }
            this.curr = param1;
            return;
        }// end function

        public function showMsg(param1:String) : void
        {
            if (this.isfull)
            {
                this.x = 275 - this.width / 2;
                this.y = 200 - this.height / 2;
            }
            else
            {
                this.x = this.rect.rx + (this.rect.rw - this.width) / 2;
                this.y = this.rect.ry + (this.rect.rh - this.height) / 2;
            }
            switch(param1)
            {
                case "connect":
                {
                    this.msgTxt.text = this.connect;
                    break;
                }
                case "offLine":
                {
                    this.msgTxt.text = this.offLine;
                    break;
                }
                case "connectError":
                {
                    this.msgTxt.text = this.connectError;
                    break;
                }
                case "waiting":
                {
                    this.msgTxt.text = "";
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.curr = param1;
            this.visible = true;
            return;
        }// end function

    }
}
