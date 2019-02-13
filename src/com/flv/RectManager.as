package com.flv
{

    public class RectManager extends Object
    {
        public static var Rect:Array = new Array();
        public static var stage:Object;
        static var Num:Number = 4;

        public function RectManager()
        {
            return;
        }// end function

        public static function setRectNum(param1:int) : void
        {
            Num = param1;
            switch(param1)
            {
                case 6:
                {
                    setVideo6();
                    break;
                }
                case 8:
                {
                    setVideo8();
                    break;
                }
                default:
                {
                    setVideo(param1);
                    break;
                }
            }
            return;
        }// end function

        static function reSizeVideo() : void
        {
            switch(Num)
            {
                case 6:
                {
                    setVideo6();
                    break;
                }
                case 8:
                {
                    setVideo8();
                    break;
                }
                default:
                {
                    setVideo(Num);
                    break;
                }
            }
            return;
        }// end function

        static function setVideo(param1:int) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:* = undefined;
            _loc_4 = Math.ceil(Math.sqrt(param1));
            _loc_2 = stage.stageWidth / _loc_4;
            _loc_3 = stage.stageHeight / _loc_4;
            var _loc_8:* = 0;
            _loc_6 = 0;
            _loc_5 = _loc_8;
            var _loc_7:* = 0;
            while (_loc_7 < param1)
            {
                
                if (Rect[_loc_7] == null)
                {
                    Rect[_loc_7] = new RECT(_loc_5, _loc_6, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                else
                {
                    Rect[_loc_7].resizeRect(_loc_5, _loc_6, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                _loc_5 = _loc_5 + 1;
                if (_loc_5 >= _loc_4)
                {
                    _loc_5 = 0;
                    _loc_6 = _loc_6 + 1;
                }
                _loc_7 = _loc_7 + 1;
            }
            return;
        }// end function

        static function setVideo6() : void
        {
            var _loc_1:* = 3;
            var _loc_2:* = stage.stageWidth / _loc_1;
            var _loc_3:* = stage.stageHeight / _loc_1;
            if (Rect[0] == null)
            {
                Rect[0] = new RECT(0, 0, 2 * _loc_2, 2 * _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[0].resizeRect(0, 0, 2 * _loc_2, 2 * _loc_3, stage.stageWidth, stage.stageHeight);
            }
            if (Rect[1] == null)
            {
                Rect[1] = new RECT(2, 0, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[1].resizeRect(2, 0, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            if (Rect[2] == null)
            {
                Rect[2] = new RECT(2, 1, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[2].resizeRect(2, 1, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            var _loc_4:* = 3;
            while (_loc_4 < 6)
            {
                
                if (Rect[_loc_4] == null)
                {
                    Rect[_loc_4] = new RECT(_loc_4 - 3, 2, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                else
                {
                    Rect[_loc_4].resizeRect(_loc_4 - 3, 2, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        static function setVideo8() : void
        {
            var _loc_1:* = 4;
            var _loc_2:* = stage.stageWidth / _loc_1;
            var _loc_3:* = stage.stageHeight / _loc_1;
            if (Rect[0] == null)
            {
                Rect[0] = new RECT(0, 0, 3 * _loc_2, 3 * _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[0].resizeRect(0, 0, 3 * _loc_2, 3 * _loc_3, stage.stageWidth, stage.stageHeight);
            }
            if (Rect[1] == null)
            {
                Rect[1] = new RECT(3, 0, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[1].resizeRect(3, 0, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            if (Rect[2] == null)
            {
                Rect[2] = new RECT(3, 1, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[2].resizeRect(3, 1, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            if (Rect[3] == null)
            {
                Rect[3] = new RECT(3, 2, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            else
            {
                Rect[3].resizeRect(3, 2, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
            }
            var _loc_4:* = 4;
            while (_loc_4 < 8)
            {
                
                if (Rect[_loc_4] == null)
                {
                    Rect[_loc_4] = new RECT(_loc_4 - 4, 3, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                else
                {
                    Rect[_loc_4].resizeRect(_loc_4 - 4, 3, _loc_2, _loc_3, stage.stageWidth, stage.stageHeight);
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

    }
}
