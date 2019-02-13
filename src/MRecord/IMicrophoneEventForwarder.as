package MRecord {
import flash.events.SampleDataEvent;

  public interface IMicrophoneEventForwarder {

    function handleMicSampleData(event:SampleDataEvent):void;

  }
}
