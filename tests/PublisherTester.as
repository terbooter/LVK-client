package {
import lvk.publisher.events.ErrorEvent;

import flash.display.Sprite;

import lvk.publisher.Publisher;

public class PublisherTester extends Sprite {
    public function PublisherTester() {
        var publisher:Publisher = new Publisher();
        addChild(publisher);
        publisher.addEventListener(ErrorEvent.ERROR, onError);
        publisher.webcamOn();
    }

    private function onError(event:ErrorEvent):void {
        trace(event);
    }
}
}
