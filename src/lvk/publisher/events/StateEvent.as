package lvk.publisher.events {
import flash.events.Event;

public class StateEvent extends Event {

    public static const STATE_CHANGE:String = "STATE_CHANGE";
    private var stateName:String;

    public function StateEvent(stateName:String) {
        super(STATE_CHANGE);
        this.stateName = stateName;
    }

    public function getStateName():String {
        return stateName;
    }
}
}
