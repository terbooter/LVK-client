package lvk.player {
import flash.events.IEventDispatcher;

[Event(name="STATE_CHANGE", type="lvk.player.events.StateEvent")]
[Event(name="ERROR", type="lvk.player.events.ErrorEvent")]
[Event(name="LOG", type="lvk.player.events.LogEvent")]

public interface IPlayer extends IEventDispatcher {

    function play(uri:String, streamName:String):void;

    function stop():void;

    function getStatus():Object;

    function setMode(width:int = 320, heigth:int = 240):void;

    function setSoundVolume(percents:Number):void;

}
}
