package MRecord {

  import flash.events.ActivityEvent;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.ProgressEvent;
  import flash.events.SampleDataEvent;
  import flash.events.SecurityErrorEvent;
  import flash.external.ExternalInterface;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundCodec;
  import flash.net.FileReference;
  import flash.net.Socket;
  import flash.utils.ByteArray;
  import flash.utils.Dictionary;
  import flash.utils.Endian;
  
  import mx.controls.Alert;
  import mx.events.CloseEvent;
  

  public class MicrophoneRecorder extends EventDispatcher {
    public static var SOUND_COMPLETE:String = "sound_complete";
    public static var PLAYBACK_STARTED:String = "playback_started";
    public static var ACTIVITY:String = "activity";

    public var mic:MicrophoneWrapper;
    public var sound:Sound = new Sound();
    public var levelObserverAttacher:MicrophoneEventObserverAttacher;
    public var levelForwarder:MicrophoneLevelForwarder;
    public var samplesObserverAttacher:MicrophoneEventObserverAttacher;
    public var samplesForwarder:MicrophoneSamplesForwarder;
    public var soundChannel:SoundChannel;
    public var sounds:Dictionary = new Dictionary();
    public var rates:Dictionary = new Dictionary();
    public var currentSoundName:String = "";
    public var currentSoundFilename:String = "";
    public var recording:Boolean = false;
    public var playing:Boolean = false;
    public var pauses:Dictionary = new Dictionary();
    public var samplingStarted:Boolean = false;
    public var latency:Number = 0;
    public var playBackStartedAt:Number;
    public var playBackLatency:Number;
    private var resampledBytes:ByteArray = new ByteArray();
	private var startTime:Date;
	
	
	private var sc:Socket;
	private var ip:String;
	private var port:int;
	private var seq:int = 0;
	private var phone:String;
	
	public var state:int = 1;

    public function MicrophoneRecorder(ip:String,port:int,phone:String)
	{
		this.phone = phone;
		this.ip = ip;
		this.port = port;
		
      this.mic = new MicrophoneWrapper();
      this.sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
      var sampleCalc:SampleCalculator = new SampleCalculator();
      levelForwarder = new MicrophoneLevelForwarder(sampleCalc);
      levelObserverAttacher = new MicrophoneEventObserverAttacher(this.mic, levelForwarder);
      samplesForwarder = new MicrophoneSamplesForwarder();
      samplesObserverAttacher = new MicrophoneEventObserverAttacher(this.mic, samplesForwarder);
    }

    public function reset():void {
      this.Stop();
      this.sounds = new Dictionary();
      this.rates = new Dictionary();
      this.currentSoundName = "";
      this.recording = false;
      this.playing = false;
      this.pauses = new Dictionary();
    }

    public function Start():void {
		connectServer(ip,port);
      
    }
	
	private function initMicrophone():void{
		var name:String="1";
		this.Stop();
		this.currentSoundName = name;
		var data:ByteArray = this.getSoundBytes(name, true);
		data.position = 0;
		this.pauses[name] = 0;
		this.rates[name] = mic.getRate();
		this.samplingStarted = true;
		this.mic.setCodec(SoundCodec.PCMA);
		this.mic.setRate(8);
		this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
		this.mic.addEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
		this.recording = true;
		this.startTime = new Date();
		this.state = 0;
	}
	
    public function playBack(name:String):void {
      this.Stop(false);
      this.currentSoundName = name;
      var data:ByteArray = this.getSoundBytesResampled(true);
      data.position = this.getSamplePosition(this.pauses[name]);
      this.samplingStarted = true;
      this.playBackLatency = 0;
      this.playBackStartedAt = 0;
      this.playing = true;
      this.soundChannel = this.sound.play();
      this.soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    }

    public function playBackFrom(name:String, time:Number=0):void {
      // Time is given as Number of seconds
      if (time > this.duration(name)) {
        return;
      }
      this.pauses[name] = time * 1000;
      this.playBack(name);
    }

    public function Stop(resetPause:Boolean=true):void {
      if(this.soundChannel) {
        this.soundChannel.stop();
        this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        this.soundChannel = null;
      }

      if(this.playing) {
        this.playing = false;
      }

      var name:String = this.currentSoundName;
      if(this.pauses[name] > 0 && resetPause) {
        this.pauses[name] = 0;
      }

      if(this.recording) {
        this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
        this.mic.removeEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
        this.recording = false;
      }
	  
	  this.state = 1;
//	  save(this.currentSoundName);
    }

    public function pause(name:String):void {
      var progress:Number = this.soundChannel.position;
      var startedFrom:Number = this.pauses[name];
      this.Stop();
      this.pauses[name] = startedFrom + progress;
    }

    public function getCurrentTime(name:String):Number {
      var time:Number = this.pauses[name];
      if (this.playing && this.currentSoundName == name) {
        time += this.soundChannel.position;
        time -= this.playBackLatency;
      }
      return time/1000; // Returns number of seconds
    }

    private function onSoundComplete(event:Event):void {
      this.Stop();
      dispatchEvent(new Event(MicrophoneRecorder.SOUND_COMPLETE));
    }

    public function getSoundBytes(name:String=null, create:Boolean=false):ByteArray {
      if(! name) {
        name = this.currentSoundName;
      }

      var data:ByteArray = ByteArray(this.sounds[name]);
      if(create) {
        if(data) {
          delete this.sounds[name];
        }
        data = new ByteArray();
        this.sounds[name] = data;
      }

      return data;
    }

    public function getSoundBytesResampled(resampling:Boolean=false):ByteArray {
      if(! resampling) {
        return resampledBytes;
      }

      var targetRate:int = 44100;
      var sourceRate:int = this.frequency();
      var data:ByteArray = this.getSoundBytes();
      data.position = 0;

      // nothing to do here
      if(sourceRate == 44100) {
        resampledBytes = data;
        resampledBytes.position = 0;
        return resampledBytes;
      }

      resampledBytes = new ByteArray();

      var multiplier:Number = targetRate / sourceRate;

      // convert the data
      var measure:int = targetRate;
      var currentSample:Number = data.readFloat();
      var nextSample:Number = data.readFloat();

      resampledBytes.writeFloat(currentSample);

      // taken from http://code.google.com/p/as3wavsound/ in Wav.as from resampleSamples()
      while(data.bytesAvailable) {
        var increment:Number = (nextSample - currentSample) / multiplier;
        var times:int = 0;
        while(measure >= sourceRate) {
          times += 1;
          resampledBytes.writeFloat(currentSample + (increment * times));
          measure -= sourceRate;
        }

        currentSample = nextSample;
        nextSample = data.readFloat();
        measure += targetRate;
      }

      resampledBytes.writeFloat(nextSample);
      resampledBytes.position = 0;

      return resampledBytes;
    }

    private function onMicrophoneActivity(event:Event):void {
      dispatchEvent(new Event(MicrophoneRecorder.ACTIVITY));
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
//      var data:ByteArray = this.getSoundBytes();
//      while(event.data.bytesAvailable) {
//        data.writeFloat(event.data.readFloat());
//      }
	  trace(event.data.length);
	  var data:ByteArray = new ByteArray();
	  data.endian = Endian.LITTLE_ENDIAN;
	  while(event.data.bytesAvailable > 0) {
		  var sample:Number = event.data.readFloat(); // The sample is stored as a sine wave, -1 to 1
		  var val:int = sample * 32768; // Convert to a 16bit integer
		  data.writeShort(val);
	  }
	  sendData(makePackage(makeTbBody(data),0x8900));
      event.data.position = 0;
    }

    private function playbackSampleHandler(event:SampleDataEvent):void {
      if (this.playBackStartedAt == 0) {
        this.playBackStartedAt = this.getNowAsNumber();
      }
      var i:int = 0;
      var sample:Number = 0.0;
      if(!this.soundChannel) {
        for (; i<3072; i++) {
          event.data.writeFloat(sample);
          event.data.writeFloat(sample);
        }
	    return;
      }

      if(this.samplingStarted && this.soundChannel) {
        this.samplingStarted = false;
        this.latency = (event.position * 2.267573696145e-02) - this.soundChannel.position;
        this.playBackLatency = this.getNowAsNumber() - this.playBackStartedAt;
        dispatchEvent(new Event(MicrophoneRecorder.PLAYBACK_STARTED));
      }

      var data:ByteArray = this.getSoundBytesResampled();
      for (; i<8192 && data.bytesAvailable && this.playing; i++) {
        sample = data.readFloat();
        event.data.writeFloat(sample);
        event.data.writeFloat(sample);
      }
    }

    private function getNowAsNumber():Number {
      return new Date().getTime();
    }

    private function getSamplePosition(time:Number):uint {
      // time is a number of milliseconds
      var position:uint = 0;
      if (time == 0) return position;
      var data:ByteArray = this.getSoundBytesResampled();
      var bytesLength:int = data.length;
      position = time * 44.1 * 4;
      position = Math.min(position, bytesLength); // prevents from returning position from out of range
      return position;                            // returns position of sample in ByteArray
    }

    public function duration(name:String=null):Number {
      if(! name) {
        name = this.currentSoundName;
      }
      var data:ByteArray = this.getSoundBytes(name);
      var frequency:int = MicrophoneRecorder.frequency(this.rates[name]);
      var numSamples:uint = data.length / 4;
      return Number(numSamples) / Number(frequency);
    }

    public function rate(name:String=null):int {
      if(! name) {
        name = this.currentSoundName;
      }
      return this.rates[name];
    }

    public function frequency(name:String=null):int {
      return MicrophoneRecorder.frequency(this.rate(name));
    }

    public static function frequency(rate:int):int {
      switch(rate) {
      case 44:
        return 44100;
      case 22:
        return 22050;
      case 11:
        return 11025;
      case 8:
        return 8000;
      case 5:
        return 5512;
      }
      return 0;
    }
	
	public function save(name:String):void{
		var alldata:ByteArray = this.getSoundBytes(name);
		if(alldata == null)
			return;
		trace("record total time="+(new Date().getTime()-startTime.getTime())/1000+"s,total size="+alldata.length);
		Alert.show("是否保存语音数据到本机？","提示",Alert.YES|Alert.NO,null,function(e:CloseEvent):void{
			if(Alert.YES == e.detail){
				//					var file:FileReference = new FileReference();
				//					file.save(alldata,"test.g711");
				var file2:FileReference = new FileReference();
				file2.save(convertToWav(name),"test.wav");
				//alldata.clear();
			}else{
				//当点击NO时的操作
			}
		});
	}
	
    public function convertToWav(name:String):ByteArray {
      return MicrophoneRecorder.convertToWav(this.getSoundBytes(name), MicrophoneRecorder.frequency(this.rates[name]));
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
  }
}
