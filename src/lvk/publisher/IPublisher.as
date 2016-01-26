package lvk.publisher {
import flash.events.IEventDispatcher;

[Event(name="STATE_CHANGE", type="lvk.publisher.events.StateEvent")]
[Event(name="ERROR", type="lvk.publisher.events.ErrorEvent")]
[Event(name="LOG", type="lvk.publisher.events.LogEvent")]
public interface IPublisher extends IEventDispatcher {

    function webcamOn():void;

    function publish(uri:String, streamName:String):void;

    function stop():void;

    function getStatus():Object;


}
}
