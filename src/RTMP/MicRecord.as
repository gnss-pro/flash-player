package RTMP
{
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.Sound;
	import flash.media.SoundCodec;
	import flash.media.Video;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import flashx.textLayout.events.DamageEvent;

	public class MicRecord
	{
		private var datas:Array = new Array();
		
		private var mic:Microphone;
		
		private var sc:Socket;
		
		private var ip:String;
		private var port:int;
		private var seq:int = 0;
		private var phone:String;
		
		public var state:int = 1;
		
		private var connected:Boolean = false;
		
		private var alldata:ByteArray;
		private var startTime:Date;
		
		public function MicRecord(ip:String,port:int,phone:String)
		{
			this.phone = phone;
			this.ip = ip;
			this.port = port;
			this.alldata = new ByteArray();
			this.alldata.endian=Endian.LITTLE_ENDIAN;
		}
		
		public function Start():void{
			connectServer(ip,port);
		}
		
		private function initMicrophone():void {  
			mic = Microphone.getEnhancedMicrophone();  
			
			if (mic) {  
				var options:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions(); 
				options.mode = MicrophoneEnhancedMode.FULL_DUPLEX;  
				options.autoGain = false;  
				options.echoPath = 128;  
				options.nonLinearProcessing = true;  
				mic.enhancedOptions=options;  
				mic.setUseEchoSuppression(true);  
			} else {  
				mic = Microphone.getMicrophone();  
			}  
			if (mic.muted)
			{
				ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "micDenied");
				this.Stop();
				return;
			}
			if (this.mic == null)
			{
				trace("mic faild");
				this.Stop();
				return ;
			}
			mic.addEventListener(StatusEvent.STATUS, onMicStatusEvent);  
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA,onRecData);
			mic.addEventListener(ActivityEvent.ACTIVITY,onActive);
//			mic.setLoopBack(false);
//			
//			var nc:NetConnection = new NetConnection();
//			nc.connect(null);
//			var audioStream:NetStream= new NetStream(nc);
//			audioStream.attachAudio(mic);
			mic.codec = SoundCodec.PCMA;
			mic.gain = 60;  
			mic.rate = 8;
//			mic.setSilenceLevel(0, -1);  
			this.state = 0;
			startTime = new Date();
			this.alldata.clear();
		}  
		
		
		public function Stop():void{
			trace("record total time="+(new Date().getTime()-startTime.getTime())/1000+"s,total size="+alldata.length);
			Alert.show("是否保存语音数据到本机？","提示",Alert.YES|Alert.NO,null,function(e:CloseEvent):void{
				if(Alert.YES == e.detail){
//					var file:FileReference = new FileReference();
//					file.save(alldata,"test.g711");
					var file2:FileReference = new FileReference();
					file2.save(convertToWav(alldata,8),"test.wav");
					alldata.clear();
				}else{
					//当点击NO时的操作
				}
			});
			this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onRecData);
			this.mic.removeEventListener(ActivityEvent.ACTIVITY, onActive);
			if(mic != null)
				mic.setSilenceLevel(100);
			if(sc.connected)
				sc.close();
			this.state = 1;
		}
		
		private function connectServer(ip:String,port:int):void{
			try{
				if(sc==null)
				{
					sc=new Socket();
					sc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function():void{
						trace("connect fail");
					});
					sc.addEventListener(Event.CONNECT,onConnect);//连接成功
					sc.addEventListener(ProgressEvent.SOCKET_DATA, onReceiveData);//接收数据
				}
				
				sc.connect(ip,port);//连接到服务器
			}catch(e:Error){
				trace(e.message);
			}
		}
		
		/**
		 * 发送对讲请求
		 */
		private function sendData(data:ByteArray):void{
			if(sc.connected){
//				ByteToHex.Trace(data);
				sc.writeBytes(data);
				sc.flush();
				data.clear();
			}
		}
		
		/**
		 * 组包
		 */
		private function makePackage(body:ByteArray,cmd:int):ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.BIG_ENDIAN;
			ba.writeMultiByte("%%cooint","UTF-8");
			ba.writeShort(cmd);
			ba.writeShort(body.length);//消息体长度
			ba.writeBytes(str2Bcd(phone));
			ba.writeShort(++seq);
			ba.writeBytes(body);
			ba.writeByte(0);
			ba.writeMultiByte("%%cooint","UTF-8");
			body.clear();
			return ba;
		}
		
		/**
		 * 音频数据组包
		 */
		private function makeTbBody(body:ByteArray):ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.length += 8;
			ba.position = ba.length;
			ba.writeInt(2);
			ba.writeInt(body.length);
			ba.writeBytes(body);
			body.clear();
			return ba;
		}
		
		/**
		 * 对讲请求组包
		 */
		private function makeRequestBody():ByteArray{
			var ba:ByteArray = new ByteArray();
			ba.writeByte(0);//设置ip长度0，不下发ip地址
			ba.writeShort(0);//服务器监听设备的端口，不设置
			ba.writeByte(0);//对讲不设置通道号
			ba.writeByte(1);//数据类型 1表示对讲
			return ba;
		}
		
		private function onConnect(e:Event):void{
			trace("connect media server success");
			ExternalInterface.call("onTtxVideoMsg", "" + 0 + "", "uploadNetConnected");
			sendData(makePackage(makeRequestBody(),0x9101));
			initMicrophone();
		}
		
		private function onReceiveData(e:ProgressEvent):void{
			var len:int = sc.bytesAvailable;
			if(len>0){
				var recData:ByteArray = new ByteArray();
				sc.readBytes(recData,0,sc.bytesAvailable);
			}
		}
		private function onActive(event:ActivityEvent):void{
			trace("活动=" + event.activating + ", 活动量=" +
				mic.activityLevel);
		}
		
		/**
		 * 对采集到的数据进行处理
		 */
		private function onRecData(event:SampleDataEvent):void{
//			var soundBytes:ByteArray = new ByteArray(); 
//			while(event.data.bytesAvailable) { 
//				var sample:Number = event.data.readFloat(); 
//				soundBytes.writeFloat(sample); 
//			}
			trace(event.data.length);
			alldata.writeBytes(event.data);
			sendData(makePackage(makeTbBody(event.data),0x8900));
//			event.data.position = 0;
//			soundBytes.clear();
		}
		
		protected function onMicStatusEvent(event:StatusEvent):void {  
			trace("New microphone status event");  
			//trace(ObjectUtil.toString(event));  
			switch (event.code) {  
				case "Microphone.Muted":  
					break;  
				case "Microphone.Unmuted":  
					break;  
				default:  
					break;  
			}  
		}
		
		private function str2Bcd(asc:String):ByteArray{
			var bcdArray:ByteArray = new ByteArray(); 
			var len:int = asc.length;  
			var mod:int = len % 2;  
			if (mod != 0) {  
				asc = "0" + asc;  
				len = asc.length;  
			}  
			for(var i:int=0;i<len;i+=2){
				var v:int = parseInt(asc.charAt(i))<<4|parseInt(asc.charAt(i+1));
				bcdArray.writeByte(v);
			}
			return bcdArray;
		}
		
		public static function convertToWav(soundBytes:ByteArray, sampleRate:int):ByteArray {
			var data:ByteArray = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			
			var numBytes:uint = soundBytes.length / 2; // soundBytes are 32bit floats, we are storing 16bit integers
			var numChannels:int = 1;
			var bitsPerSample:int = 16;
			
			// The following is from https://ccrma.stanford.edu/courses/422/projects/WaveFormat/
			
			data.writeUTFBytes("RIFF"); // ChunkID
			data.writeUnsignedInt(36 + numBytes); // ChunkSize
			data.writeUTFBytes("WAVE"); // Format
			data.writeUTFBytes("fmt "); // Subchunk1ID
			data.writeUnsignedInt(16); // Subchunk1Size // 16 for PCM
			data.writeShort(1); // AudioFormat 1 Mono, 2 Stereo (Microphone is mono)
			data.writeShort(numChannels); // NumChannels
			data.writeUnsignedInt(sampleRate); // SampleRate
			data.writeUnsignedInt(sampleRate * numChannels * bitsPerSample/8); // ByteRate
			data.writeShort(numChannels * bitsPerSample/8); // BlockAlign
			data.writeShort(bitsPerSample); // BitsPerSample
			data.writeUTFBytes("data"); // Subchunk2ID
			data.writeUnsignedInt(numBytes); // Subchunk2Size
			
			soundBytes.position = 0;
			while(soundBytes.bytesAvailable > 0) {
				var sample:Number = soundBytes.readFloat(); // The sample is stored as a sine wave, -1 to 1
				var val:int = sample * 32768; // Convert to a 16bit integer
				data.writeShort(val);
			}
			return data;
		}
		
	}
}