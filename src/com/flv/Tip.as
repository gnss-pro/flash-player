package com.flv
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import mx.core.BitmapAsset;
	import mx.core.FlexShape;
	
	public class Tip extends MovieClip
	{
		[Embed(source="../images/tipbg.svg")]  
		[Bindable]
		private var bg:Class;
		
		public var lable:TextField=new TextField();
		public function Tip()
		{
//			var shape:FlexShape = new FlexShape();
//			shape.graphics.beginBitmapFill(BitmapAsset(new bg()).bitmapData);
//			shape.graphics.endFill();
//			addChild(shape);
			addChild(lable);
		}
	}
}