package lvk.publisher {
import flash.display.Sprite;

import lvk.player.IPlayer;
import lvk.player.Player;
import lvk.publisher.events.*;

public class LiveDelayPublisher extends Sprite implements IPublisher {

    private var publisher:IPublisher;
    private var player:IPlayer;
    private var isLiveDelay:Boolean = false;

    public function LiveDelayPublisher() {
        publisher = new Publisher();
        publisher.addEventListener(StateEvent.STATE_CHANGE, onState);
        publisher.addEventListener(ErrorEvent.ERROR, onError);
        publisher.addEventListener(LogEvent.LOG, onLog);

        player = new Player();
        addChild(publisher as Sprite);
    }

    public function webcamOn():void {
        publisher.webcamOn();
    }

    public function liveDelayON():void {
        if (contains(publisher as Sprite)) {
            removeChild(publisher as Sprite);
        }

        addChild(player as Sprite);
        trace("uri=" + publisher.getStatus().uri);
        trace("streamName=" + publisher.getStatus().streamName);
        player.setSoundVolume(0);
        player.play(publisher.getStatus().uri, publisher.getStatus().streamName);
        isLiveDelay = true;
    }

    public function publish(uri:String, streamName:String):void {
        publisher.publish(uri, streamName);
    }

    public function stop():void {
        publisher.stop();
    }

    public function getStatus():Object {
        var o:Object = publisher.getStatus();
        o.liveDelay = isLiveDelay;
        return o;
    }

    public function setMode(width:int, height:int, fps:int = 0):void {
        publisher.setMode(width, height);
        player.setMode(width, height);
    }

    public function takeScreenshot(uploadURL:String, jpgFile:String, token:String, width:int = 160, heigth:int = 120, customParam:String = null):void {
        publisher.takeScreenshot(uploadURL, jpgFile, token, width, heigth, customParam);
    }

    private function onState(event:StateEvent):void {
        var e:StateEvent = new StateEvent(event.getStateName());
        dispatchEvent(e);
    }

    private function onError(event:ErrorEvent):void {
        dispatchEvent(new ErrorEvent(event.getCode(), event.getMessage()));
    }

    private function onLog(event:LogEvent):void {
        dispatchEvent(new LogEvent(event.getMessage()));
    }
}
}
