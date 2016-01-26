package lvk.player.events {
import flash.events.Event;

public class LogEvent extends Event {
    public static const LOG:String = "LOG";
    private var message:String;

    public function LogEvent(message:String) {
        super(LogEvent.LOG);
        this.message = message;
    }

    public function getMessage():String {
        return message;
    }

}
}
