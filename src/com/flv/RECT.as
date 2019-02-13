package com.flv
{

    public class RECT extends Object
    {
        public var rw:Number;
        public var rh:Number;
        public var rx:Number;
        public var ry:Number;
        public var sw:Number;
        public var sh:Number;
		
		
		/**
		 * param1 列号
		 * param2 行号
		 * param3 当前宽
		 * param4 当前高
		 * param5 总宽
		 * param6 总高
		 */
        public function RECT(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            this.sw = param5;
            this.sh = param6;
            this.rh = param4 - 2;
            this.rw = param3 - 2;
//            this.rx = param1 * param3 + 1 - param5 / 2 + 275;
//            this.ry = param2 * param4 + 1 - param6 / 2 + 200;
			this.rx = param1 * param3 + 1;
			this.ry = param2 * param4 + 1;
            return;
        }// end function

        public function resizeRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            this.sw = param5;
            this.sh = param6;
            this.rh = param4 - 2;
            this.rw = param3 - 2;
//            this.rx = param1 * param3 + 1 - param5 / 2 + 275;
//            this.ry = param2 * param4 + 1 - param6 / 2 + 200;
			this.rx = param1 * param3 + 1;
			this.ry = param2 * param4 + 1;
            return;
        }// end function

    }
}
