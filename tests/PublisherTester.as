package {
import flash.display.DisplayObject;

import lvk.publisher.IPublisher;
import lvk.publisher.events.ErrorEvent;

import flash.display.Sprite;

import lvk.publisher.Publisher;

public class PublisherTester extends Sprite {
    public function PublisherTester() {
        trace("Publisher Tester");
        var publisher:IPublisher = new Publisher();
        addChild(publisher as DisplayObject);
        publisher.addEventListener(ErrorEvent.ERROR, onError);
        publisher.webcamOn();
        publisher.publish('rtmp://lvk.cloudapp.net:1937/vod', 'liveStream01');

//        publisher.setMode(500, 375);
        publisher.setMode(480, 360);

    }

    private function onError(event:ErrorEvent):void {
        trace(event);
    }

    //У каждой камеры свой набор нативных разрешений
    // Например, моей камере задаешь разрешение 480x360 а она выставляет 320x240

    private function iterateResolutions(publisher:IPublisher):void {
        var width:int = 0;
        var height:int = 0;
        for (var step:int = 1; step <= 1600; step++) {
            width = step;
            height = Math.floor(width / 4 * 3);
            publisher.setMode(width, height);
        }
    }
}
}
