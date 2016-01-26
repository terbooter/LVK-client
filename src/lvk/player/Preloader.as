package lvk.player {

import flash.display.Sprite;
import flash.events.Event;

import net.stevensacks.preloaders.CircleSlicePreloader;

public class Preloader extends Sprite {
    private var preloader:Sprite = new CircleSlicePreloader(12, 6);
    private var model:PlayerModel;

    public function Preloader(model:PlayerModel) {
        this.model = model;
        addChild(preloader);
        preloader.x = (320 ) / 2;
        preloader.y = (240 ) / 2;

        model.addEventListener(Event.CHANGE, onChange);
    }

    private function onChange(event:Event):void {
        var state:String = model.getState();
        if (state == State.CONNECTING || state == State.OPENING) {
            addChild(preloader);
        } else if (state == State.STOPPED) {
            if (contains(preloader)) {
                removeChild(preloader);
            }
        }
    }
}
}
