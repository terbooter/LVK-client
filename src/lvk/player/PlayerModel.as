package lvk.player {


import flash.events.Event;
import flash.events.EventDispatcher;

public class PlayerModel extends EventDispatcher {

    private var state:String;
    public var uri:String;
    public var streamName:String;

    public function PlayerModel() {
    }

    public function setState(newState:String):void {
        trace("SET STATE ", newState);
        if (newState == state) {
            return;
        }

        state = newState;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function getState():String {
        return state;
    }
}
}
