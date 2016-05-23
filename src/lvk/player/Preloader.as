package lvk.player {

import flash.display.Sprite;
import flash.events.Event;

import net.stevensacks.preloaders.CircleSlicePreloader;

public class Preloader extends Sprite {
    private var preloader:Sprite = new CircleSlicePreloader(12, 6);
    private var model:PlayerModel;

    private var videoWidth:int = 320;
    private var videoHeigth:int = 240;

    public function Preloader(model:PlayerModel, videoWidth:int, videoHeigth:int) {
        this.videoWidth = videoWidth;
        this.videoHeigth = videoHeigth;

        this.model = model;
        addChild(preloader);
        preloader.x = videoWidth / 2;
        preloader.y = videoHeigth / 2;

        model.addEventListener(Event.CHANGE, onChange);
    }

    public function setSize(videoWidth:int, videoHeigth:int):void {
        this.videoWidth = videoWidth;
        this.videoHeigth = videoHeigth;

        preloader.x = videoWidth / 2;
        preloader.y = videoHeigth / 2;
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
