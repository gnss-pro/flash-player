package com.flv
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UITextField;
	
	public class infoBar extends MovieClip
	{
		var infoTxt:TextField = new TextField();
		var BackGround:VideoInfoBg = new VideoInfoBg();
		public function infoBar()
		{
//			this.y = 5;
			infoTxt.height = 30;
			addChild(BackGround);
			addChild(infoTxt);
			
		}
		
	}
}