package com.flv 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.controls.Text;
	import mx.core.BitmapAsset;
	import mx.core.FlexShape;
	import mx.core.SpriteAsset;
	import mx.states.State;
	
	import spark.primitives.BitmapImage;

    dynamic public class innerBtnCap extends innerBtn
    {
		[Embed(source="../images/cap3.png")]  
		[Bindable]    
		private var en:Class;  
        
		[Embed(source="../images/cap2.png")]  
		[Bindable]    
		private var dis:Class;
		
		[Embed(source="../images/cap1.png")]  
		[Bindable]
		private var over:Class;
		private var img:Bitmap = new Bitmap();
		public function innerBtnCap()
        {
			var data:BitmapData = BitmapAsset(new en()).bitmapData;
			img.bitmapData = data;
			img.y = 5;
			addChild(img);
			super();
			return;
        }// end function
		
		public override function switchFrame(index:int):void{
			if(index == 1){
				img.bitmapData = BitmapAsset(new en()).bitmapData;
			}else if(index == 2){
				img.bitmapData = BitmapAsset(new over()).bitmapData;
			}else if(index == 3){
				img.bitmapData = BitmapAsset(new dis()).bitmapData;
			}
		}
		
    }
}
